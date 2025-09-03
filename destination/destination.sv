
class destination_agent extends uvm_agent;

	`uvm_component_utils(destination_agent)

	destination_driver dst_drv;
	destination_monitor dst_mon;
	destination_sequencer dst_sqrh;
	
	destination_config dst_cfg;	

	extern function new(string name="destination_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function destination_agent::new(string name="destination_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void destination_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(destination_config)::get(this,"","destination_config",dst_cfg))	
	`uvm_fatal("DESTINATION AGENT","CANNOT GET THE CONFIG")
	dst_mon=destination_monitor::type_id::create("dst_mon",this);
	if(dst_cfg.is_active==1)
	begin
		dst_drv=destination_driver::type_id::create("dst_drv",this);
		dst_sqrh=destination_sequencer::type_id::create("dst_sqrh",this);
	end
endfunction

function void destination_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	if(dst_cfg.is_active==1)
	begin
		dst_drv.seq_item_port.connect(dst_sqrh.seq_item_export);
	end
endfunction
	
	
