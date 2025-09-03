class source_driver extends uvm_driver#(source_xtn);

	`uvm_component_utils(source_driver)
	
	virtual router_if.SRC_DRV vif;
	source_config src_cfg;	
	
	extern function new(string name="source_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(source_xtn xtn);
	extern function void connect_phase(uvm_phase phase);
endclass

function source_driver::new(string name="source_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void source_driver::build_phase(uvm_phase phase);

	if(!uvm_config_db#(source_config)::get(this,"","source_config",src_cfg))
	`uvm_fatal("SOURCE_","CANNOT GET THE CONFIG")
	super.build_phase(phase);
endfunction

function void source_driver::connect_phase(uvm_phase phase);
	vif=src_cfg.vif;
endfunction


task source_driver::run_phase(uvm_phase phase);

	@(vif.drv_cb);
	vif.drv_cb.resetn<=1'b0;

	@(vif.drv_cb);
	vif.drv_cb.resetn<=1'b1;
	forever

		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
endtask


task source_driver::send_to_dut(source_xtn xtn);
	wait(vif.drv_cb.busy==0)

	vif.drv_cb.pkt_valid<=1'b1;
	vif.drv_cb.data_in<=xtn.header;

	@(vif.drv_cb);
	foreach(xtn.payload[i])
		begin
			wait(vif.drv_cb.busy==0)
			vif.drv_cb.data_in<=xtn.payload[i];
			@(vif.drv_cb);
		end
	vif.drv_cb.pkt_valid<=1'b0;
	vif.drv_cb.data_in<=xtn.parity;
	`uvm_info("DRIVER","THE DATA TO DUT IS",UVM_LOW)
	xtn.print();


endtask
