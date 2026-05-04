package ram_rst_seq_pkg;
import shared_pkg::*;
import ram_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_rst_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_rst_seq)
	ram_seq_item seq_item;
	
	function new(string name = "ram_rst_seq");
		super.new(name);
	endfunction

	task body;
		seq_item = ram_seq_item::type_id::create("seq_item");
		start_item(seq_item);
		seq_item.rst_n = 0;
		seq_item.din = 0;
		seq_item.rx_valid = 0;
		finish_item(seq_item);
	endtask 
endclass
endpackage