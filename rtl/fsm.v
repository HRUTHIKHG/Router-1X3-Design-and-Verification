
module fsm(clk,rst,pkt_valid,parity_done,soft_reset_0,
	soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
	fifo_empty_0,fifo_empty_1,fifo_empty_2,data_in,
	busy,laf_state,write_en_reg,rst_int_reg,lfd_state,
	ld_state,full_state,detect_add);
	input clk,rst,pkt_valid,parity_done,soft_reset_0,
	soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
	fifo_empty_0,fifo_empty_1,fifo_empty_2;
	input [1:0]data_in;
	output busy,laf_state,write_en_reg,rst_int_reg,lfd_state,
	ld_state,full_state,detect_add;
	reg[2:0]ps,ns;
parameter decoder_address=3'b000,
	load_first_data=3'b001,
	wait_till_empty=3'b010,
	load_data=3'b011,
	load_parity=3'b100,
	fifo_full_state=3'b101,
	load_after_full=3'b110,
	check_parity_error=3'b111;
always@(posedge clk)
begin
	if(!rst)
		ps<=decoder_address;
	else
		ps<=ns;
end
always@(*)
begin
case(ps)
		decoder_address:if((pkt_valid&&(data_in[1:0]==0)&&fifo_empty_0)||
			(pkt_valid&&(data_in[1:0]==1)&&fifo_empty_1)||
			(pkt_valid&&(data_in[1:0]==2)&&fifo_empty_2))
			ns=load_first_data;
			else if((pkt_valid&(data_in[1:0]==0)&!fifo_empty_0)|
			(pkt_valid&(data_in[1:0]==1)&!fifo_empty_1)|
			(pkt_valid&(data_in[1:0]==2)&!fifo_empty_2))
			ns=wait_till_empty;
			else
				ns=decoder_address;
			load_first_data:ns=load_data;
			wait_till_empty:if((fifo_empty_0&&(data_in[1:0]==0))||
				(fifo_empty_1&&(data_in[1:0]==1))||
				(fifo_empty_2&&(data_in[1:0]==2)))
				ns=load_first_data;
				else 
					ns=wait_till_empty;
				load_data:if(fifo_full)
				ns=fifo_full_state;
			else if(!fifo_full&&!pkt_valid)
				ns=load_parity;
			else 
				ns=load_data;
			load_parity:ns=check_parity_error;
			fifo_full_state:if(fifo_full)
			ns=fifo_full_state;
		else if(!fifo_full)
			ns=load_after_full;
		load_after_full:if(parity_done)
		ns=decoder_address;
	else if(!parity_done&&low_pkt_valid)
		ns=load_parity;
	else if(!parity_done&&!low_pkt_valid)
		ns=load_data;
	check_parity_error:if(fifo_full)
	ns=fifo_full_state;
else if(!fifo_full)
	ns=decoder_address;
default:ns=decoder_address;
endcase
end
assign detect_add=(ps==decoder_address)?1'b1:1'b0;
assign lfd_state=(ps==load_first_data)?1'b1:1'b0;
assign ld_state=(ps==load_data)?1'b1:1'b0;
assign full_state=(ps==fifo_full_state)?1'b1:1'b0;
assign rst_int_reg=(ps==check_parity_error)?1'b1:1'b0;
assign laf_state=(ps==load_after_full)?1'b1:1'b0;
assign busy=(ps==fifo_full_state||ps==load_first_data||ps==load_parity||
ps==load_after_full||ps==wait_till_empty)?1'b1:1'b0;
assign write_en_reg=(ps==load_parity||ps==load_data||ps==load_after_full)?1'b1:1'b0;
endmodule

