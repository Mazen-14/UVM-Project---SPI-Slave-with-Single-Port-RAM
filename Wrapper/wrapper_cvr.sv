package wrapper_cvr_pkg;
import uvm_pkg::*;
import wrapper_sequence_item_pkg::*;
`include "uvm_macros.svh"
class wrapper_coveragecollector extends uvm_component;
    `uvm_component_utils(wrapper_coveragecollector)
    wrapper_seq_item seq_item;
    uvm_analysis_export #(wrapper_seq_item) cvr_export;
    uvm_tlm_analysis_fifo #(wrapper_seq_item) cvr_fifo;

    function new(string name = "wrapper_coveragecollector",uvm_component parent = null);
        super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cvr_export = new("cvr_export",this);
        cvr_fifo = new("cvr_fifo",this);
    endfunction
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cvr_export.connect(cvr_fifo.analysis_export);
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cvr_fifo.get(seq_item);
        end
    endtask
endclass
endpackage