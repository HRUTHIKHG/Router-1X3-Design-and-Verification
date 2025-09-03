class source_xtn extends uvm_sequence_item;

	`uvm_object_utils(source_xtn)

	bit resetn,pkt_valid,error,busy;
	
	rand bit[7:0]header,payload[];

	bit [7:0] parity;

	constraint c1{soft header[1:0]!=2'b11;}

	constraint valid_length{soft header[7:2]!=0;}	
	
	constraint valid_depth{payload.size==header[7:2];}
	
	extern function new(string name="source_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
endclass

function source_xtn::new(string name="source_xtn");
	super.new(name);
endfunction

function void source_xtn::do_print(uvm_printer printer);
	super.do_print(printer);

	printer.print_field("header",  this.header,  8, UVM_HEX);

	foreach(payload[i])

	printer.print_field($sformatf("payload[%0d]",i), this.payload[i], 8, UVM_HEX);

	printer.print_field("parity", this.parity,8,UVM_HEX);

	printer.print_field("error",this.error,1,UVM_BIN);	
endfunction

function void source_xtn::post_randomize();

	parity=header;

	foreach(payload[i])
	begin
	
		parity^=payload[i];

	end
endfunction
