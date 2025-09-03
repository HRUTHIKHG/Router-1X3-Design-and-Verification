class destination_xtn extends uvm_sequence_item;

	`uvm_object_utils(destination_xtn)

	bit [7:0]header,payload[];
	rand bit[5:0]delay;
	bit [7:0]parity;
	extern function new(string name="destination_xtn");
	extern function void do_print(uvm_printer printer);
endclass

function destination_xtn::new(string name="destination_xtn");
	super.new(name);

endfunction


function void destination_xtn::do_print(uvm_printer printer);
	super.do_print(printer);

	printer.print_field("header",  this.header,  8, UVM_HEX);

	foreach(payload[i])

	printer.print_field($sformatf("payload[%0d]",i), this.payload[i], 8, UVM_HEX);

	printer.print_field("parity", this.parity,8,UVM_HEX);

endfunction

