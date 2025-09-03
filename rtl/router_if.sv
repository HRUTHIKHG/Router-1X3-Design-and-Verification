
interface router_if(input bit clock);

	logic[7:0]data_in,data_out;
	logic pkt_valid,resetn,error,busy,read_en,valid_out;

	clocking drv_cb@(posedge clock);
		default input#0 output#0;
		output resetn,pkt_valid,data_in;
		input busy;
	endclocking

	clocking mon_cb@(posedge clock);
		default input#0 output#0;
	input data_in,resetn,pkt_valid,busy,error;
	endclocking

	clocking ddrv_cb@(posedge clock);
		default input#1 output#1;
		output read_en;
		input valid_out;
	endclocking

	clocking dmon_cb@(posedge clock);
		default input#1 output#1;
		input data_out,read_en,valid_out;
	endclocking

		

	modport SRC_DRV(clocking drv_cb);
	modport SRC_MON(clocking mon_cb);
	modport DST_DRV(clocking ddrv_cb);
	modport DST_MON(clocking dmon_cb);

endinterface:router_if
