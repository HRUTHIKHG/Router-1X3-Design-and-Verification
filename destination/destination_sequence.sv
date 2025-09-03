class destination_sequence extends uvm_sequence#(destination_xtn);

`uvm_object_utils(destination_sequence)

extern function new(string name="destination_sequence");

endclass

function destination_sequence::new(string name="destination_sequence");
	super.new(name);
endfunction


//normal 

class normal_sequence extends destination_sequence;

	`uvm_object_utils(normal_sequence)

extern function new(string name="normal_sequence");
extern task body();

endclass

function normal_sequence::new(string name="normal_sequence");
	super.new(name);
endfunction
task normal_sequence::body();
begin
	req=destination_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with{delay<30;});
	finish_item(req);
end
endtask


//soft_reset

class softreset_sequence extends destination_sequence;

	`uvm_object_utils(softreset_sequence)

extern function new(string name="softreset_sequence");
extern task body();

endclass

function softreset_sequence::new(string name="softreset_sequence");
	super.new(name);
endfunction
task softreset_sequence::body();
begin
	req=destination_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with{delay>30;});
	finish_item(req);

end
endtask









