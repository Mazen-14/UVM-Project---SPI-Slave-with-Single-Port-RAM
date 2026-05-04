package wrapper_driver_pkg;
import uvm_pkg::*;
import wrapper_sequence_item_pkg::*;
`include "uvm_macros.svh"
class wrapper_driver extends uvm_driver#(wrapper_seq_item);
    `uvm_component_utils(wrapper_driver)
    virtual wrapper_IF wrapper_driver_vif;
    wrapper_seq_item seq_item;

    function new(string name = "wrapper_driver",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = wrapper_seq_item :: type_id:: create("seq_item");
            seq_item_port.get_next_item(seq_item);
            wrapper_driver_vif.MOSI      = seq_item.MOSI;
            wrapper_driver_vif.rst_n     = seq_item.rst_n;
            wrapper_driver_vif.SS_n      = seq_item.SS_n; 
            @(negedge wrapper_driver_vif.clk);
            seq_item_port.item_done();
            `uvm_info("run_phase",seq_item.convert2string_stimulus(),UVM_HIGH);
        end
    endtask

endclass
endpackage
