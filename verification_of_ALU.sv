`include "uvm_macros.svh"
import uvm_pkg::*;

//////////// Interface ///////////////////////

interface intf(input logic clk, input logic rst);
    	logic [7:0] op1;
    	logic [7:0] op2;
    	logic enable;
    	logic [2:0] fn;
    	logic [15:0]out_put;
    	logic output_valid;
endinterface


//////////// Transaction class ////////////////	

class my_transaction extends uvm_sequence_item;

	rand logic [7:0] op1;
    	rand logic [7:0] op2;
    	rand logic enable;
    	randc logic [2:0] fn;
    	logic [15:0]out_put;
    	logic output_valid;
	constraint c1 { fn >0 && op1 >0 && op1<100 && op2 >0 && op2 <100 ;};
	function new(string name = "my_transaction");
		super.new(name);
	endfunction
	`uvm_object_utils_begin(my_transaction)
		`uvm_field_int(op1, UVM_ALL_ON)
		`uvm_field_int(op2, UVM_ALL_ON)
		`uvm_field_int(enable, UVM_ALL_ON)
		`uvm_field_int(fn, UVM_ALL_ON)
        `uvm_object_utils_end
endclass

//////////// Sequence (Generator) ////////////

class my_seq extends uvm_sequence#(my_transaction);
	`uvm_object_utils(my_seq)
	
	function new(string name = "my_seq");
		super.new(name);
	endfunction
	
	task body();
	    repeat(10)begin 
		my_transaction trans;
		trans = my_transaction :: type_id :: create("trans");
		assert(trans.randomize() with { trans.enable == 1; });
		trans.print();
		start_item(trans);
		finish_item(trans);
            end
	endtask

endclass


///////////// Sequencer ////////////////////////

class my_sequencer extends uvm_sequencer#(my_transaction);
	`uvm_component_utils(my_sequencer)
	function new(string name = " my_sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction
endclass


//////////// Driver ////////////////////

class my_driver extends uvm_driver#(my_transaction);
	`uvm_component_utils(my_driver)
	virtual intf vif;
	
	function new(string name="my_driver", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
    			`uvm_fatal("NOVIF", "virtual interface not set for driver");
		end
	endfunction
	task run_phase(uvm_phase phase);
		my_transaction trans;
		forever begin
			seq_item_port.get_next_item(trans);
			vif.op1 <= trans.op1;
			vif.op2 <= trans.op2;
			vif.enable <= trans.enable;
			vif.fn <= trans.fn;
			@(posedge vif.clk);
			seq_item_port.item_done();
		end
	endtask
endclass


///////////// Monitor /////////

class my_monitor extends uvm_monitor;

	`uvm_component_utils(my_monitor)
	virtual intf vif;
	uvm_analysis_port#(my_transaction) ap;

	 function new(string name="my_monitor", uvm_component parent);
		super.new(name,parent);
		ap = new("ap",this);
	 endfunction

	 function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
    		if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
      			`uvm_fatal("NOVIF", "Virtual interface not set for monitor");
  	 endfunction
	
	  task run_phase(uvm_phase phase);
    		my_transaction trans;
    		forever begin
      		@(posedge vif.clk); // sample every clock edge
		#1;
      		if (vif.output_valid) begin
        	trans = my_transaction::type_id::create("trans");
        	trans.op1          = vif.op1;
        	trans.op2          = vif.op2;
        	trans.fn           = vif.fn;
        	trans.enable       = vif.enable;
        	trans.out_put      = vif.out_put;
        	trans.output_valid = vif.output_valid;

       		 ap.write(trans);  // send it out
        	`uvm_info("MON", $sformatf("Observed: %s", trans.convert2string()), UVM_MEDIUM);
      		end
    		end
 	endtask
endclass


///////// Scoreboard /////////////


class sb extends uvm_component;
	`uvm_component_utils(sb)
	uvm_tlm_analysis_fifo#(my_transaction) fifo;
	logic[15:0] trans_q[$];
	function new(string name = "sb", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		fifo = new("fifo", this);
	endfunction
	task run_phase (uvm_phase phase);	
		my_transaction trans;
    		logic [15:0] expected;
		forever begin
		fifo.get(trans);
    		case(trans.fn)
      		3'd0: expected = trans.op1 + trans.op2;
      		3'd1: expected = trans.op1 - trans.op2;
      		3'd2: expected = trans.op1 * trans.op2;
      		3'd3: expected = trans.op1 / trans.op2;
      		3'd4: expected = trans.op1 & trans.op2;
      		3'd5: expected = trans.op1 | trans.op2;
     		3'd6: expected = ~(trans.op1 & trans.op2);
      		3'd7: expected = ~(trans.op1 | trans.op2);
    		endcase
		trans_q.push_back(expected);
		if(trans_q.size > 1) begin
		logic [15:0] exp = trans_q.pop_front();
		if (trans.out_put !== exp) begin
      			`uvm_error("SCOREBOARD", $sformatf("Mismatch! DUT=%0h Expected=%0h",trans.out_put, expected));
    		end
    		else begin
      			`uvm_info("SCOREBOARD", $sformatf("Match: %0h", trans.out_put), UVM_LOW);
    		end
		end
		end
	endtask
endclass

////////////// Agent /////////////////

class my_agent extends uvm_agent;
	`uvm_component_utils(my_agent)
	my_sequencer seq;
	my_driver dri;
	my_monitor mon;
	virtual intf vif;
	
	function new(string name = "my_agent", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
      			`uvm_fatal("NOVIF", "Virtual interface must be set for ALU agent");
    		end
		mon = my_monitor :: type_id :: create("mon",this);
		mon.vif = vif;
		if(get_is_active() == UVM_ACTIVE) begin
			seq = my_sequencer :: type_id :: create ("seq",this);
			dri = my_driver :: type_id :: create("dri",this);
			dri.vif = vif;
		end
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(get_is_active() == UVM_ACTIVE)
			dri.seq_item_port.connect(seq.seq_item_export);
	endfunction
endclass


//////////// Environment ////////////

class my_env extends uvm_env;
	`uvm_component_utils(my_env)
	
	my_agent age;
	sb my_sb;
 	function new(string name ="my_env", uvm_component parent);
		super.new(name,parent);
	endfunction
		
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		age = my_agent :: type_id :: create ("age",this);
		my_sb = sb :: type_id :: create("my_sb",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		age.mon.ap.connect(my_sb.fifo.analysis_export);
	endfunction 
endclass


///////// Test //////// 

class test extends uvm_test;
	`uvm_component_utils(test)
	my_env env;
	my_seq seq_h;
	function new(string name ="test", uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = my_env :: type_id :: create ("env",this);
		uvm_config_db#(uvm_active_passive_enum) :: set (null,"env.age","is_active",UVM_ACTIVE);
		seq_h = my_seq :: type_id :: create ("seq_h",this);
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq_h.start(env.age.seq);
		phase.drop_objection(this);
	endtask
endclass


/////// Top ///////////////


module verification_of_ALU ();
	reg clk;
	reg rst;

	intf vif(clk,rst);
	ALU_CON dut (.clk(clk),
		     .rst(rst),
		     .op1(vif.op1),
		     .op2(vif.op2),
	             .enable(vif.enable),
		     .fn(vif.fn),
		     .out_put(vif.out_put),
		     .output_valid(vif.output_valid));
	always #5 clk = ~clk;
	initial begin
		clk =0; rst = 1;
		#10 rst = 0;
		uvm_config_db#(virtual intf)::set(null, "*", "vif", vif);
		run_test("test");
	end
endmodule