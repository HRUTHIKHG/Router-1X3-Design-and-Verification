class destination_driver extends uvm_driver#(destination_xtn);
`uvm_component_utils(destination_driver)

virtual router_if.DST_DRV vif;
destination_config dst_cfg;

extern function new(string name="destination_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(destination_xtn req);
endclass

function destination_driver::new(string name="destination_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void destination_driver::build_phase(uvm_phase phase);
if(!uvm_config_db#(destination_config)::get(this,"","destination_config",dst_cfg))
`uvm_fatal("DST DRIVER","CANNOT GET THE CONFIG")
super.build_phase(phase);
endfunction

function void destination_driver::connect_phase(uvm_phase phase);
	vif=dst_cfg.vif;
endfunction

task destination_driver::run_phase(uvm_phase phase);
forever
	begin
	
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	`uvm_info("DESTINATION_DRIVER","DATA SENDING TO DUT ARE",UVM_LOW)
	req.print();
	seq_item_port.item_done();	
	end
endtask

task destination_driver::send_to_dut(destination_xtn req);
begin
	wait(vif.ddrv_cb.valid_out==1)
	repeat(req.delay)
	@(vif.ddrv_cb);
	vif.ddrv_cb.read_en<=1'b1;
	@(vif.ddrv_cb);
	wait(vif.ddrv_cb.valid_out==0)
	@(vif.ddrv_cb);
	vif.ddrv_cb.read_en<=1'b0;
	@(vif.ddrv_cb);
	@(vif.ddrv_cb);

end
endtask
	
