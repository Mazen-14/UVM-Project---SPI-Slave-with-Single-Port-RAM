package wrapper_write_read_sequence_pkg;
import wrapper_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class wrapper_write_read_seq extends uvm_sequence #(wrapper_seq_item);
`uvm_object_utils(wrapper_write_read_seq)
	wrapper_seq_item seq_item;
	
	function new(string name = "wrapper_write_read_seq");
		super.new(name);
	endfunction

	task body;
		seq_item = wrapper_seq_item::type_id::create("seq_item");
		seq_item.rd_wr.constraint_mode(1); //reopen after closing
		seq_item.rd_c.constraint_mode(0);
		seq_item.wr_c.constraint_mode(0);
	    repeat(17000) begin
			start_item(seq_item);
				assert(seq_item.randomize());
			finish_item(seq_item);
		end
	endtask 
endclass
endpackage