module topblock(clk,rst,re0,re1,re2,pkt_valid,data_out_0,data_in,
	data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);
input clk,rst,re0,re1,re2,pkt_valid;
input[7:0]data_in;
output[7:0]data_out_0,data_out_1,data_out_2;
output vld_out_0,vld_out_1,vld_out_2,err,busy;
wire soft_reset_0,soft_reset_1,soft_reset_2,parity_done,fifo_full,
	low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,full0,
	full1,full2,detect_add,ld_state,laf_state,full_state,
	write_en_reg,rst_int_reg,lfd_state;
wire[2:0]wr_en;
wire[7:0]dout;

fsm fsm1(.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.parity_done(parity_done),.
	soft_reset_0(soft_reset_0),.soft_reset_1(soft_reset_1),.soft_reset_2(
	soft_reset_2),.fifo_full(fifo_full),.low_pkt_valid(low_pkt_valid),.
	fifo_empty_0(fifo_empty_0),.fifo_empty_1(fifo_empty_1),.fifo_empty_2(
	fifo_empty_2),.data_in(data_in[1:0]),.busy(busy),.laf_state(laf_state),.
	lfd_state(lfd_state),.ld_state(ld_state),.full_state(full_state),.
	detect_add(detect_add),.write_en_reg(write_en_reg),.rst_int_reg(rst_int_reg));

register register1(.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.data_in(data_in),.fifo_full(fifo_full),.
	rst_int_reg(rst_int_reg),.detect_add(detect_add),.ld_state(ld_state),.laf_state(
	laf_state),.full_state(full_state),.lfd_state(lfd_state),.parity_done(parity_done)
	,.low_pkt_valid(low_pkt_valid),.error(err),.dout(dout));

	sync sync1(.clk(clk),.rst(rst),.detect_add(detect_add),.data_in(data_in[1:0]),.
		write_en_reg(write_en_reg),.re_0(re0),.re_1(re1),.re_2(re2),.wr_en(wr_en),.
		fifo_full(fifo_full),.empty0(fifo_empty_0),.empty1(fifo_empty_1),.empty2(fifo_empty_2),.full0(full0),.
		full1(full1),.full2(full2),.soft_rst0(soft_reset_0),.soft_rst1(soft_reset_1),.
		soft_rst2(soft_reset_2),.valid_out0(vld_out_0),.valid_out1(vld_out_1),.valid_out2(vld_out_2));

	fifo fifo0(.clk(clk),.rst(rst),.soft_rst(soft_reset_0),.re(re0),.we(wr_en[0]),.
		lfd_state(lfd_state),.empty(fifo_empty_0),.full(full0),.data_in(dout),.
		data_out(data_out_0));


	fifo fifo1(.clk(clk),.rst(rst),.soft_rst(soft_reset_1),.re(re1),.we(wr_en[1]),.
		lfd_state(lfd_state),.empty(fifo_empty_1),.full(full1),.data_in(dout),.
		data_out(data_out_1));


	fifo fifo2(.clk(clk),.rst(rst),.soft_rst(soft_reset_2),.re(re2),.we(wr_en[2]),.
		lfd_state(lfd_state),.empty(fifo_empty_2),.full(full2),.data_in(dout),.
		data_out(data_out_2));
	endmodule
