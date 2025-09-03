
module sync(detect_add,data_in,write_en_reg,clk,rst,
	re_0,re_1,re_2,wr_en,fifo_full,empty0,empty1,empty2,soft_rst0,
	soft_rst1,soft_rst2,full0,full1,full2,valid_out0,valid_out1,valid_out2);
input detect_add,write_en_reg,clk,rst,re_0,re_1,
re_2,empty0,empty1,empty2,full0,full1,full2;
input[1:0]data_in;
output reg valid_out0,valid_out1,valid_out2;
output reg fifo_full,soft_rst0,soft_rst1,soft_rst2;
output reg[2:0]wr_en;
reg[1:0]fifo_add;
reg[4:0]count_soft_rst0;
reg[4:0]count_soft_rst1;
reg[4:0]count_soft_rst2;
//capture the address
always@(posedge clk)
begin
	if(!rst)
		fifo_add<=0;
	else if(detect_add)
		fifo_add<=data_in;
end
//write enable signal
always@(*)
begin
	if(write_en_reg)
		case(fifo_add)
			2'b00:wr_en=3'b001;
			2'b01:wr_en=3'b010;
			2'b10:wr_en=3'b100;
			default:wr_en=3'b000;
		endcase
	end
//fifo_full logic
always@(*)
begin
	case(fifo_add)
		2'b00:fifo_full=full0;
		2'b01:fifo_full=full1;
		2'b10:fifo_full=full2;
		default:fifo_full=1'b1;
	endcase
end
//valid out
always@(*)
begin
valid_out0<=!empty0;
valid_out1<=!empty1;
valid_out2<=!empty2;
end
/*
assign valid_out_0=!empty0&&!full0;
assign valid_out_1=!empty1&&!full1;
assign valid_out_2=!empty2&&!full2;*/

//soft reset logic
always@(posedge clk)
begin
	if(!rst)
	begin
		soft_rst0<=0;
	count_soft_rst0<=0;
	end
	else if(!valid_out0)
		begin
		soft_rst0<=0;
	count_soft_rst0<=0;
	end
	else if(re_0==1)
		begin
		soft_rst0<=0;
	count_soft_rst0<=0;
	end
	else if(count_soft_rst0<=29)
	begin
		soft_rst0<=0;
		count_soft_rst0<=count_soft_rst0+1;
	end
	else
		begin
		soft_rst0<=1;
	count_soft_rst0<=0;
end
end

always@(posedge clk)
begin
	if(!rst)
		begin
		soft_rst1<=0;
	count_soft_rst1<=0;
	end
	else if(!valid_out1)
		begin
		soft_rst1<=0;
	count_soft_rst1<=0;
	end
	else if(re_1==1)
		begin
		soft_rst1<=0;
	count_soft_rst1<=0;
	end
	else if(count_soft_rst1<=29)
	begin
		soft_rst1<=0;
		count_soft_rst1<=count_soft_rst1+1;
	end
	else
		begin
		soft_rst1<=1;
	count_soft_rst1<=0;
end
end

always@(posedge clk)
begin
	if(!rst)
	begin
		soft_rst2<=0;
	count_soft_rst2<=0;
	end
	else if(!valid_out2)
		begin
		soft_rst2<=0;
	count_soft_rst2<=0;
	end
	else if(re_2==1)
		begin
		soft_rst2<=0;
	count_soft_rst2<=0;
	end
	else if(count_soft_rst2<=29)
	begin
		soft_rst2<=0;
		count_soft_rst2<=count_soft_rst2+1;
	end
	else
		begin
		soft_rst2<=1;
	count_soft_rst2<=0;
end
end
endmodule
