package spi_scoreboard_pkg;
import uvm_pkg::*;
import spi_sequence_item_pkg::*;
`include "uvm_macros.svh"

class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)

    spi_seq_item seq_item;
    uvm_analysis_export #(spi_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(spi_seq_item) sb_fifo;

    logic [5:0]  out_ref;
    logic [15:0] leds_ref;

    int correct_counter = 0;
    int error_counter   = 0;

    function new(string name = "spi_scoreboard",uvm_component parent = null);
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
            if ((seq_item.rx_data != seq_item.rx_data_ref || seq_item.rx_valid != seq_item.rx_valid_ref || seq_item.MISO != seq_item.MISO_ref))
                error_counter++;
            else
                correct_counter++;
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Final Counters for spi %d,%d", correct_counter, error_counter);
    endfunction


endclass
endpackage
