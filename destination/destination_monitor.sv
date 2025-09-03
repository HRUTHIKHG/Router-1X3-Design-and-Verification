class destination_monitor extends uvm_monitor;
        `uvm_component_utils(destination_monitor)

        virtual router_if.DST_MON vif;
        destination_config dst_cfg;
        destination_xtn xtn;
      uvm_analysis_port#(destination_xtn) ap;



        extern function new(string name="destination_monitor",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();
endclass

function destination_monitor::new(string name="destination_monitor",uvm_component parent);

        super.new(name,parent);
	ap=new("ap",this);
endfunction

function void destination_monitor::build_phase(uvm_phase phase);

        if(!uvm_config_db#(destination_config)::get(this,"","destination_config",dst_cfg))
        `uvm_fatal("DESTINATION","CANNOT GET THE CONFIG")
        super.build_phase(phase);
endfunction

function void destination_monitor::connect_phase(uvm_phase phase);
vif=dst_cfg.vif;
endfunction

task destination_monitor::run_phase(uvm_phase phase);
        begin
                collect_data();
        end
endtask

task destination_monitor::collect_data();
        xtn=destination_xtn::type_id::create("xtn");
	 wait(vif.dmon_cb.read_en==1)
	@(vif.dmon_cb);
        xtn.header=vif.dmon_cb.data_out;
        xtn.payload=new[xtn.header[7:2]];
	@(vif.dmon_cb);
        foreach(xtn.payload[i])
                begin

                        xtn.payload[i]=vif.dmon_cb.data_out;
                        @(vif.dmon_cb);
                end
        xtn.parity=vif.dmon_cb.data_out;


`uvm_info("DST_MONITOR","THE DATA MONITOR RECIEVED FROM DUT IS",UVM_LOW);
xtn.print();
      ap.write(xtn);
endtask

