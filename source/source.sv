class source_agent extends uvm_agent;

	`uvm_component_utils(source_agent)

	source_driver src_drv;
	source_monitor src_mon;
	source_sequencer src_sqrh;
	
	source_config src_cfg;	

	extern function new(string name="source_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function source_agent::new(string name="source_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void source_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(source_config)::get(this,"","source_config",src_cfg))	
	`uvm_fatal("SOURCE AGENT","CANNOT GET THE CONFIG")
	src_mon=source_monitor::type_id::create("src_mon",this);
	if(src_cfg.is_active==UVM_ACTIVE)
	begin
		src_drv=source_driver::type_id::create("src_drv",this);
		src_sqrh=source_sequencer::type_id::create("src_sqrh",this);
	end
endfunction

function void source_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	if(src_cfg.is_active==UVM_ACTIVE)
	begin
		src_drv.seq_item_port.connect(src_sqrh.seq_item_export);
	end
endfunction
	
	
