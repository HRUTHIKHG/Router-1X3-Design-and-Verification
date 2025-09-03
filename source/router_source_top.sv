class router_source_top extends uvm_env;

	`uvm_component_utils(router_source_top)

	env_config env_cfg;
	
	source_agent src[];	

	extern function new(string name="router_source_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

	function router_source_top::new(string name="router_source_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void router_source_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("source_top","cannot get the config")
		src=new[env_cfg.no_of_src_agt];
		
		foreach(src[i])
			begin
				src[i]=source_agent::type_id::create($sformatf("src[%0d]",i),this);
				uvm_config_db#(source_config)::set(this,$sformatf("src[%0d]*",i),"source_config",env_cfg.src_cfg[i]);
			end
	endfunction


