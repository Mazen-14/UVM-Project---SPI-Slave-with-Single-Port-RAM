package spi_main_sequence_pkg;
import uvm_pkg::*;
import spi_sequence_item_pkg::*;
`include "uvm_macros.svh"
class spi_main_sequence extends uvm_sequence #(spi_seq_item);
    `uvm_object_utils(spi_main_sequence)
    spi_seq_item seq;
    function new(string name = "spi_main_sequence");
        super.new(name);
    endfunction
    task body;
        seq = spi_seq_item ::type_id::create("seq");
        repeat(50000)begin
            start_item(seq);
            assert(seq.randomize());
            finish_item(seq);
        end
    endtask
endclass
endpackage