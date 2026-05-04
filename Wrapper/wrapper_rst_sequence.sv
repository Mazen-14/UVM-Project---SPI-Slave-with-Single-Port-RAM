package wrapper_rst_sequence_pkg;
import shared_pkg::*;
import wrapper_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class wrapper_rst_seq extends uvm_sequence #(wrapper_seq_item);
`uvm_object_utils(wrapper_rst_seq)
	wrapper_seq_item seq_item;
	
	function new(string name = "wrapper_rst_seq");
		super.new(name);
	endfunction

	task body;
		seq_item = wrapper_seq_item::type_id::create("seq_item");
		start_item(seq_item);
		seq_item.rst_n = 0;
		seq_item.MOSI = 0;
		finish_item(seq_item);
	endtask 
endclass
endpackage