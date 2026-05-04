package ram_write_read_seq_pkg;
import ram_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_write_read_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_read_seq)
	ram_seq_item seq_item;
	
	function new(string name = "ram_write_read_seq");
		super.new(name);
	endfunction

	task body;
		seq_item = ram_seq_item::type_id::create("seq_item");
		seq_item.rd_wr.constraint_mode(1); //reopen after closing
		seq_item.rd_c.constraint_mode(0);
	    repeat(17000) begin
			start_item(seq_item);
			assert(seq_item.randomize());
			finish_item(seq_item);
		end
	endtask 
endclass
endpackage