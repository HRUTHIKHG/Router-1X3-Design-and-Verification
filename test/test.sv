class router_test extends uvm_test;
	
	`uvm_component_utils(router_test)
	
	env_config env_cfg;
	
	source_config src_cfg[];
	destination_config dst_cfg[];
	
	router_env env;
 	
	int no_of_src_agt=1;
	int no_of_dst_agt=3;


	extern function new(string name="router_test",uvm_component parent);
	extern function void router_config();
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
endclass:router_test


function router_test::new(string name="router_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test::router_config();
	begin
	src_cfg=new[no_of_src_agt];
       
	
	foreach(src_cfg[i])
		begin
			src_cfg[i]=source_config::type_id::create($sformatf("src_cfg[%0d]",i));
		
			if(!uvm_config_db#(virtual router_if)::get(this,"","vif",src_cfg[i].vif))
			`uvm_fatal("UVM_TEST","CANNOT GET INTERFACE TO SOURCE")
			$display("----------------------%p",src_cfg[i]);
			src_cfg[i].is_active=UVM_ACTIVE;
			env_cfg.src_cfg[i]=src_cfg[i];
		end
	
	end

	begin
	dst_cfg=new[no_of_dst_agt];

	foreach(dst_cfg[i])
		begin
			dst_cfg[i]=destination_config::type_id::create($sformatf("dst_cfg[%0d]",i));


			if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("vif_%0d",i),dst_cfg[i].vif))
			`uvm_fatal("UVM_TEST","CANNOT GET INTERFACE TO DESTINATION")
			$display("---------------------%p",dst_cfg[i]);
			dst_cfg[i].is_active=UVM_ACTIVE;
			env_cfg.dst_cfg[i]=dst_cfg[i];
		end
	end

	env_cfg.no_of_src_agt=no_of_src_agt;
	env_cfg.no_of_dst_agt=no_of_dst_agt;
endfunction




function void router_test::build_phase(uvm_phase phase);
	env_cfg=env_config::type_id::create("env_cfg");
	env_cfg.src_cfg=new[no_of_src_agt];
	env_cfg.dst_cfg=new[no_of_dst_agt];
	router_config();
	uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
	super.build_phase(phase);
	env=router_env::type_id::create("env",this);
endfunction

function void router_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction


//small packet

class small_packet extends router_test;
`uvm_component_utils(small_packet)
bit[1:0]addr;
small_packet_seq small_pkt;
normal_sequence normal;

extern function new(string name="small_packet",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function small_packet::new(string name="small_packet",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void small_packet::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task small_packet::run_phase(uvm_phase phase);
begin
	addr=2'b00;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);
$display("the address is %0d",addr);
	small_pkt=small_packet_seq::type_id::create("small_pkt");
	normal=normal_sequence::type_id::create("normal");

	phase.raise_objection(this);
fork
	
	small_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join

 /// #100;
end	phase.drop_objection(this);



endtask


class small_packet1 extends router_test;
`uvm_component_utils(small_packet1)
bit[1:0]addr;
small_packet_seq small_pkt;
normal_sequence normal;

extern function new(string name="small_packet1",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function small_packet1::new(string name="small_packet1",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void small_packet1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task small_packet1::run_phase(uvm_phase phase);
begin
	addr=2'b01;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);
$display("the address is %0d",addr);
	small_pkt=small_packet_seq::type_id::create("small_pkt");
	normal=normal_sequence::type_id::create("normal");

	phase.raise_objection(this);
fork
	
	small_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join

 /// #100;
end	phase.drop_objection(this);



endtask


class small_packet2 extends router_test;
`uvm_component_utils(small_packet2)
bit[1:0]addr;
small_packet_seq small_pkt;
normal_sequence normal;

extern function new(string name="small_packet2",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function small_packet2::new(string name="small_packet2",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void small_packet2::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task small_packet2::run_phase(uvm_phase phase);
begin
	addr=2'b10;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);
$display("the address is %0d",addr);
	small_pkt=small_packet_seq::type_id::create("small_pkt");
	normal=normal_sequence::type_id::create("normal");

	phase.raise_objection(this);
fork
	
	small_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join

 /// #100;
end	phase.drop_objection(this);



endtask
//medium_packet

class medium_packet extends router_test;
`uvm_component_utils(medium_packet)
bit[1:0]addr;
medium_packet_seq medium_pkt;

normal_sequence normal;

extern function new(string name="medium_packet",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function medium_packet::new(string name="medium_packet",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void medium_packet::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task medium_packet::run_phase(uvm_phase phase);
begin

	addr=2'b01;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);

$display("the address is %0d",addr);
	medium_pkt=medium_packet_seq::type_id::create("medium_pkt");
	normal=normal_sequence::type_id::create("normal");
	
	phase.raise_objection(this);
fork
	medium_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join
end
	phase.drop_objection(this);

endtask

class medium_packet1 extends router_test;
`uvm_component_utils(medium_packet1)
bit[1:0]addr;
medium_packet_seq medium_pkt;

normal_sequence normal;

extern function new(string name="medium_packet1",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function medium_packet1::new(string name="medium_packet1",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void medium_packet1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task medium_packet1::run_phase(uvm_phase phase);
begin

	addr=2'b00;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);

$display("the address is %0d",addr);
	medium_pkt=medium_packet_seq::type_id::create("medium_pkt");
	normal=normal_sequence::type_id::create("normal");
	
	phase.raise_objection(this);
fork
	medium_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join
end	phase.drop_objection(this);

endtask

class medium_packet2 extends router_test;
`uvm_component_utils(medium_packet2)
bit[1:0]addr;
medium_packet_seq medium_pkt;

normal_sequence normal;

extern function new(string name="medium_packet2",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function medium_packet2::new(string name="medium_packet2",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void medium_packet2::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task medium_packet2::run_phase(uvm_phase phase);
begin

	addr=2'b10;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);

$display("the address is %0d",addr);
	medium_pkt=medium_packet_seq::type_id::create("medium_pkt");
	normal=normal_sequence::type_id::create("normal");
	
	phase.raise_objection(this);
fork
	medium_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join
end	phase.drop_objection(this);

endtask




//large_packet
class large_packet extends router_test;
`uvm_component_utils(large_packet)
bit[1:0]addr;
large_packet_seq large_pkt;
normal_sequence normal;

extern function new(string name="large_packet",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function large_packet::new(string name="large_packet",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void large_packet::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task large_packet::run_phase(uvm_phase phase);
begin	
addr=2'b10;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);

$display("the address is %0d",addr);
	large_pkt=large_packet_seq::type_id::create("large_pkt");
	normal=normal_sequence::type_id::create("normal");

	phase.raise_objection(this);
fork
	large_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join

//#100;
end	phase.drop_objection(this);

endtask

class large_packet1 extends router_test;
`uvm_component_utils(large_packet1)
bit[1:0]addr;
large_packet_seq large_pkt;
normal_sequence normal;

extern function new(string name="large_packet1",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function large_packet1::new(string name="large_packet1",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void large_packet1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task large_packet1::run_phase(uvm_phase phase);
begin	
addr=2'b00;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);

$display("the address is %0d",addr);
	large_pkt=large_packet_seq::type_id::create("large_pkt");
	normal=normal_sequence::type_id::create("normal");

	phase.raise_objection(this);
fork
	large_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join

//#100;
end	phase.drop_objection(this);


endtask

class large_packet2 extends router_test;
`uvm_component_utils(large_packet2)
bit[1:0]addr;
large_packet_seq large_pkt;
normal_sequence normal;

extern function new(string name="large_packet2",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function large_packet2::new(string name="large_packet2",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void large_packet2::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task large_packet2::run_phase(uvm_phase phase);
begin	
addr=2'b01;
	uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);

$display("the address is %0d",addr);
	large_pkt=large_packet_seq::type_id::create("large_pkt");
	normal=normal_sequence::type_id::create("normal");

	phase.raise_objection(this);
fork
	large_pkt.start(env.src_top.src[0].src_sqrh);
	normal.start(env.dst_top.dst[addr].dst_sqrh);
join

//#100;
end	phase.drop_objection(this);

endtask

