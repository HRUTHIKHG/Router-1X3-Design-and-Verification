class router_sequence extends uvm_sequence#(source_xtn);
	`uvm_object_utils(router_sequence)

	extern function new(string name="router_sequence");

endclass

function router_sequence::new(string name="router_sequence");
	super.new(name);
endfunction

//small packet

class small_packet_seq extends router_sequence;

`uvm_object_utils(small_packet_seq)

bit[1:0]addr;

extern function new(string name="small_packet_seq");
extern task body();

endclass

function small_packet_seq::new(string name="small_packet_seq");
	super.new(name);
endfunction

task small_packet_seq::body();
begin
	req=source_xtn::type_id::create("req");

	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))

	`uvm_fatal("SMALLPACKET","CANNOT GET THE CONFIG")

	start_item(req);

assert(req.randomize() with{header[1:0]==addr; header[7:2] inside {[1:20]};});

	finish_item(req);
end
endtask

//medium_packet

class medium_packet_seq extends router_sequence;

`uvm_object_utils(medium_packet_seq)

bit[1:0]addr;

extern function new(string name="medium_packet_seq");
extern task body();

endclass

function medium_packet_seq::new(string name="medium_packet_seq");
	super.new(name);
endfunction

task medium_packet_seq::body();
begin
	req=source_xtn::type_id::create("req");

	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))

	`uvm_fatal("MEDIUMPACKET","CANNOT GET THE CONFIG")

	start_item(req);

	assert(req.randomize() with{header[1:0]==addr; header[7:2]inside{[21:40]};});

	finish_item(req);
end
endtask


//large_packet

class large_packet_seq extends router_sequence;

`uvm_object_utils(large_packet_seq)

bit[1:0]addr;

extern function new(string name="large_packet_seq");
extern task body();

endclass

function large_packet_seq::new(string name="large_packet_seq");
	super.new(name);
endfunction

task large_packet_seq::body();
begin
	req=source_xtn::type_id::create("req");

	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))

	`uvm_fatal("LARGEPACKET","CANNOT GET THE CONFIG")
	
	start_item(req);

	assert(req.randomize() with{header[1:0]==addr; header[7:2] inside {[41:63]};});

	finish_item(req);
end
endtask
