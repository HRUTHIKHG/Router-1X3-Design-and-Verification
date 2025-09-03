module top;
	
	import router_pkg::*;

	import uvm_pkg::*;


	bit clock;
	always
	#10 clock=!clock;

	router_if in(clock); 
	router_if in0(clock);
	router_if in1(clock);
	router_if in2(clock);

	topblock DUV(.clk(clock),
			.rst(in.resetn),
			.pkt_valid(in.pkt_valid),
			.data_in(in.data_in),
			.err(in.error),
			.busy(in.busy),
			.re0(in0.read_en),
			.vld_out_0(in0.valid_out),
			.data_out_0(in0.data_out),
			.re1(in1.read_en),
			.vld_out_1(in1.valid_out),
			.data_out_1(in1.data_out),
			.re2(in2.read_en),
			.vld_out_2(in2.valid_out),
			.data_out_2(in2.data_out));


	initial
		
		begin

`ifdef VCS
$fsdbDumpvars(0,top);
`endif			
			uvm_config_db#(virtual router_if)::set(null,"*","vif",in);
			uvm_config_db#(virtual router_if)::set(null,"*","vif_0",in0);
			uvm_config_db#(virtual router_if)::set(null,"*","vif_1",in1);
			uvm_config_db#(virtual router_if)::set(null,"*","vif_2",in2);
	

			run_test();
	
		end

property stable_data;
@(posedge clock) in.busy |=> $stable(in.data_in);
endproperty

property busy_check;
@(posedge clock) $rose(in.pkt_valid) |=> in.busy;
endproperty

property valid_signal;
@(posedge clock) $rose(in.pkt_valid) |-> ##3(in0.valid_out|in1.valid_out|in2.valid_out);
endproperty

property read_en1;
@(posedge clock) in0.valid_out |=> ##[1:29]in0.read_en;
endproperty

property read_en2;
@(posedge clock) in1.valid_out |=> ##[1:29]in1.read_en;
endproperty

property read_en3;
@(posedge clock) in2.valid_out |=> ##[1:29]in2.read_en;
endproperty

property read_en_low1;
@(posedge clock) $fell(in0.valid_out) |=> $fell(in0.read_en);
endproperty

property read_en_low2;
@(posedge clock) $fell(in1.valid_out) |=> $fell(in1.read_en);
endproperty

property read_en_low3;
@(posedge clock) $fell(in2.valid_out) |=> $fell(in2.read_en);
endproperty

assert property(stable_data);
assert property(valid_signal);
assert property(busy_check);
assert property(read_en1);
assert property(read_en2);
assert property(read_en3);
assert property(read_en_low1);
assert property(read_en_low2);
assert property(read_en_low3);

endmodule
