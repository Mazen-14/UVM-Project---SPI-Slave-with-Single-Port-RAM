package wrapper_read_only_sequence_pkg;
import shared_pkg::*;
import wrapper_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class wrapper_read_only_seq extends uvm_sequence #(wrapper_seq_item);
`uvm_object_utils(wrapper_read_only_seq)
	wrapper_seq_item seq_item;
	
	function new(string name = "wrapper_read_only_seq");
		super.new(name);
	endfunction

	task body;
		seq_item = wrapper_seq_item::type_id::create("seq_item");
		seq_item.wr_c.constraint_mode(0); //closing to prevent conflict 
		seq_item.rd_wr.constraint_mode(0); //closing to prevent conflict 
	    repeat(17000) begin
			start_item(seq_item);
    		assert(seq_item.randomize() with {MOSI_bits[9:8] inside {[2:3]};});
			finish_item(seq_item);
		end
	endtask 
endclass
endpackage