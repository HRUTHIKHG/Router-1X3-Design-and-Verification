class env_config extends uvm_object;

	`uvm_object_utils(env_config)
bit has_wagent=1;
bit has_ragent=1;
bit has_virtual_sequencer=1;
bit has_scoreboard=1;
int no_of_dst_agt=3;
int no_of_src_agt=1;

	source_config src_cfg[];
	destination_config dst_cfg[];


	extern function new(string name="env_config");

endclass:env_config

function env_config::new(string name="env_config");
	super.new(name);
endfunction
