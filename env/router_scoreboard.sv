class router_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(router_scoreboard)

	uvm_tlm_analysis_fifo#(source_xtn) fifo_src;
	uvm_tlm_analysis_fifo#(destination_xtn)fifo_dst[];

	source_xtn src;
	destination_xtn dst;


	env_config env;

	source_xtn src_cov_data;
	destination_xtn dst_cov_data;

	int data_verified;


	extern function new(string name="router_scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void check_data(destination_xtn xtn);
	
	covergroup router_fcov1;

	option.per_instance=1;


	CHANNEL:coverpoint src_cov_data.header[1:0]{ bins low={2'b00};
						     bins mid1={2'b01};
						     bins mid2={2'b10};}

	PAYLOAD: coverpoint src_cov_data.header[7:2]{bins small_pkt={[1:20]};
						     bins medium_pkt={[21:40]};
						     bins large_pkt={[41:63]};}

	ERR:coverpoint src_cov_data.error{bins err={0};}

	CH:cross CHANNEL,PAYLOAD;
	CH1:cross CHANNEL,PAYLOAD,ERR;
endgroup

	covergroup router_fcov2;

	option.per_instance=1;


	CHANNEL:coverpoint dst_cov_data.header[1:0]{ bins low={2'b00};
						     bins mid1={2'b01};
						     bins mid2={2'b10};}

	PAYLOAD: coverpoint dst_cov_data.header[7:2]{bins small_pkt={[1:20]};
						     bins medium_pkt={[21:40]};
						     bins large_pkt={[41:63]};}


	CH:cross CHANNEL,PAYLOAD;
endgroup

endclass

function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
	super.new(name,parent);
	router_fcov1=new();
	router_fcov2=new();
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(env_config)::get(this,"","env_config",env))
	`uvm_fatal("SCOREBOARD","CANNOT GET THE CONFIG")

	fifo_src=new("fifo_src",this);
	fifo_dst=new[env.no_of_dst_agt];
	foreach(fifo_dst[i])
	begin
		fifo_dst[i]=new($sformatf("fifo_dst[%0d]",i),this);
	end
endfunction


task router_scoreboard::run_phase(uvm_phase phase);
fork 
	begin
		forever
			begin
				fifo_src.get(src);
				`uvm_info("SRC_SB","SRC_DATA",UVM_LOW)
				src.print();
				src_cov_data=src;
				router_fcov1.sample();
			end
	end

	begin
		forever
			begin
				fork
					begin
						fifo_dst[0].get(dst);
						`uvm_info("DST[0]","DST_DATA",UVM_LOW)	
						dst.print();
						check_data(dst);
						dst_cov_data=dst;
						router_fcov2.sample();
					end
					
					begin
						fifo_dst[1].get(dst);
						`uvm_info("DST[1]","DST_DATA",UVM_LOW)	
						dst.print();
						check_data(dst);
						dst_cov_data=dst;
						router_fcov2.sample();
					end
					
					begin
						fifo_dst[2].get(dst);
						`uvm_info("DST[2]","DST_DATA",UVM_LOW)	
						dst.print();
						check_data(dst);
						dst_cov_data=dst;
						router_fcov2.sample();
					end
				join_any
				disable fork;
			end

		end
	join
endtask

function void router_scoreboard::check_data(destination_xtn xtn);
	if(src.header==dst.header)
		`uvm_info("HEADER","HEADER COMPARISON SUCCESSFULL",UVM_LOW)
	else
		`uvm_info("HEADER","NOT SUCCESSFUL COMPARISON",UVM_LOW)

	foreach(src.payload[i])
	begin	
	if(src.payload[i]==dst.payload[i])
		`uvm_info("PAYLOAD",$sformatf("PAYLOAD[%0d] COMPARISON SUCCESSFUL",i),UVM_LOW)
	else
		`uvm_info("PAYLOAD",$sformatf("NOT SUCCESSFUL COMPARISON AT [%0d]",i),UVM_LOW)
	end
	
	if(src.parity==dst.parity)
		`uvm_info("PARITY","PARITY COMPARISON SUCCESSFUL",UVM_LOW)
	else
		`uvm_info("PARITY","NOT SUCCESSFUL COMPARISON",UVM_LOW)
endfunction




