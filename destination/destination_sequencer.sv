class destination_sequencer extends uvm_sequencer#(destination_xtn);

	`uvm_component_utils(destination_sequencer)

extern function new(string name="destination_sequencer",uvm_component parent);

endclass

function destination_sequencer ::new(string name="destination_sequencer",uvm_component parent);

	super.new(name,parent);

endfunction

