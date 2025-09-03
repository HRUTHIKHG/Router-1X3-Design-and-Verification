class source_monitor extends uvm_monitor;

	`uvm_component_utils(source_monitor)

	virtual router_if.SRC_MON vif;
	source_config src_cfg;
	source_xtn xtn;
	uvm_analysis_port#(source_xtn) ap;



	extern function new(string name="source_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

function source_monitor::new(string name="source_monitor",uvm_component parent);

	super.new(name,parent);
	ap=new("ap",this);
endfunction

function void source_monitor::build_phase(uvm_phase phase);

	if(!uvm_config_db#(source_config)::get(this,"","source_config",src_cfg))
	`uvm_fatal("SOURCE","CANNOT GET THE CONFIG")
	super.build_phase(phase);
endfunction

function void source_monitor::connect_phase(uvm_phase phase);
vif=src_cfg.vif;
endfunction

task source_monitor::run_phase(uvm_phase phase);
forever
	begin
		collect_data();
	end
endtask

task source_monitor::collect_data();
	xtn=source_xtn::type_id::create("xtn");
	wait(vif.mon_cb.busy==0)

	wait(vif.mon_cb.pkt_valid==1)

	
	xtn.header=vif.mon_cb.data_in;
	xtn.payload=new[xtn.header[7:2]];
	@(vif.mon_cb);
	@(vif.mon_cb);
	foreach(xtn.payload[i])
		begin
			wait(vif.mon_cb.busy==0)
			
			xtn.payload[i]=vif.mon_cb.data_in;
			@(vif.mon_cb);
		end

	wait(vif.mon_cb.pkt_valid==0)
	xtn.parity=vif.mon_cb.data_in;

	@(vif.mon_cb);
	@(vif.mon_cb);
	xtn.error=vif.mon_cb.error;
`uvm_info("MONITOR","THE DATA MONITOR RECIEVED FROM INTERFACE IS",UVM_LOW);
xtn.print();
	ap.write(xtn);
endtask
