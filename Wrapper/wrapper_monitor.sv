package wrapper_monitor_pkg;
import uvm_pkg::*;
import wrapper_sequence_item_pkg::*;
`include "uvm_macros.svh"
class wrapper_monitor extends uvm_monitor;
    `uvm_component_utils(wrapper_monitor)
    virtual wrapper_IF v_if;
    wrapper_seq_item seq_item;
    uvm_analysis_port #(wrapper_seq_item) mon_ap;
    
    function new(string name = "wrapper_monitor",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = wrapper_seq_item::type_id::create("seq_item");
            seq_item.MOSI      = v_if.MOSI;
            seq_item.rst_n     = v_if.rst_n;
            seq_item.SS_n      = v_if.SS_n;
            seq_item.MISO      = v_if.MISO;
            seq_item.MISO_ref  = v_if.MISO_ref;
            @(negedge v_if.clk);
            mon_ap.write(seq_item);
        end
    endtask
endclass
endpackage