module register(clk,rst,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,
	ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,
	error,dout);
input clk,rst,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,
	full_state,lfd_state;
input [7:0]data_in;
output reg parity_done,low_pkt_valid,error;
output reg [7:0]dout;
reg[7:0]hold_header_byte;
reg[7:0]fifo_full_byte;
reg[7:0]internal_parity;
reg[7:0]packet_parity;

always@(posedge clk)
begin
	if(!rst)
		dout<=8'b0;
	else
	begin
		if(detect_add&&pkt_valid)
			hold_header_byte<=data_in;
		else if(lfd_state)
			dout<=hold_header_byte;
		else if(ld_state&&!fifo_full)
			dout<=data_in;
		else if(ld_state&&fifo_full)
			fifo_full_byte<=data_in;
		else if(laf_state)
			dout<=fifo_full_byte;
	end
end
//packet parity logic
always@(posedge clk)
begin
	if(!rst)
		packet_parity<=8'b0;
	else if(!pkt_valid&&ld_state)
		packet_parity<=data_in;
end
//internal parity
always@(posedge clk)
begin
	if(!rst)
		internal_parity<=8'b0;
	else if(lfd_state)
		internal_parity<=internal_parity^hold_header_byte;
	else if(ld_state&&pkt_valid&&!full_state)
		internal_parity<=internal_parity^data_in;
	else if(detect_add)
		internal_parity<=8'b0;
end
//error generation
always@(posedge clk)
begin
	if(!rst)
		error<=1'b0;
	else
	begin
		if(!pkt_valid)
		begin
			if(internal_parity!==packet_parity)
				error<=1'b1;
			else
				error<=1'b0;
		end
	end
end
//parity done logic
always@(posedge clk)
begin
	if(!rst)
		parity_done<=1'b0;
	else if(ld_state&&!fifo_full&&!pkt_valid)
		parity_done<=1'b1;
	else if(laf_state&&!pkt_valid)
		parity_done<=1'b1;
	else
		parity_done<=1'b0;
end
//low packet valid
always@(posedge clk)
begin
	if(!rst)
		low_pkt_valid<=1'b0;
	else
	begin
		if(rst_int_reg)
			low_pkt_valid<=1'b0;
		if(ld_state&&!pkt_valid)
			low_pkt_valid<=1'b1;
	end
end
endmodule
