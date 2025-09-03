class router_env extends uvm_env;

	`uvm_component_utils(router_env)

	router_source_top src_top;
	router_destination_top dst_top;


//	router_virtual_sequencer vsqrh;

	router_scoreboard sb;

	env_config env_cfg;

	extern function new(string name="router_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
//	extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function router_env::new(string name="router_env",uvm_component parent);
	super.new(name,parent);
endfunction


function void router_env::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
	`uvm_fatal("ENV","CANNOT GET THE CONFIG")
begin	
	
		src_top=router_source_top::type_id::create("src_top",this);
end	

	begin
		dst_top=router_destination_top::type_id::create("dst_top",this);
	end

/*	if(env_cfg.has_virtual_sequencer)
		begin
			vsqrh=router_virtual_sequencer::type_id::create("vsqrh");
		end
*/
	if(env_cfg.has_scoreboard)
		begin
			sb=router_scoreboard::type_id::create("sb",this);
		end
endfunction

function void router_env::connect_phase(uvm_phase phase);
   		     if(env_cfg.has_scoreboard) 
	begin	
		foreach(src_top.src[i])	
					begin
						src_top.src[i].src_mon.ap.connect(sb.fifo_src.analysis_export);
					end
		foreach(dst_top.dst[i])
					begin				
						dst_top.dst[i].dst_mon.ap.connect(sb.fifo_dst[i].analysis_export);
					end
	end
endfunction
