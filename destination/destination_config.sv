class destination_config extends uvm_object;

	`uvm_object_utils(destination_config)
	
	virtual router_if vif;
	
	uvm_active_passive_enum is_active=UVM_ACTIVE;
	
	extern function new(string name="destination_config");

endclass:destination_config

function destination_config::new(string name="destination_config");
	super.new(name);
endfunction
