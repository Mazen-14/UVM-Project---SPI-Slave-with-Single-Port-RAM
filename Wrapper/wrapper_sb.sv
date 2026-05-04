package wrapper_scoreboard_pkg;
import uvm_pkg::*;
import wrapper_sequence_item_pkg::*;
`include "uvm_macros.svh"

class wrapper_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(wrapper_scoreboard)

    wrapper_seq_item seq_item;
    uvm_analysis_export #(wrapper_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(wrapper_seq_item) sb_fifo;

    int correct_counter = 0;
    int error_counter   = 0;

    function new(string name = "wrapper_scoreboard",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo   = new("sb_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item);
            if (seq_item.MISO != seq_item.MISO_ref)
                error_counter++;
            else
                correct_counter++;
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Final Counters for wrapper %d,%d", correct_counter, error_counter);
    endfunction


endclass
endpackage
