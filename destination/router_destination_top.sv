
class router_destination_top extends uvm_env;

	`uvm_component_utils(router_destination_top)

	env_config env_cfg;
	
	destination_agent dst[];	

	extern function new(string name="router_destination_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

	function router_destination_top::new(string name="router_destination_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void router_destination_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("destination_top","cannot get the config")
		dst=new[env_cfg.no_of_dst_agt];
		
		foreach(dst[i])
			begin
				dst[i]=destination_agent::type_id::create($sformatf("dst[%0d]",i),this);
				uvm_config_db#(destination_config)::set(this,$sformatf("dst[%0d]*",i),"destination_config",env_cfg.dst_cfg[i]);
			end
	endfunction


