package ram_scoreboard_pkg;
import ram_seq_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(ram_scoreboard)
  uvm_analysis_export #(ram_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
  ram_seq_item seq_item;
  integer error_count = 0;
  integer correct_count = 0;

  function new(string name = "ram_scoreboard", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sb_fifo.get(seq_item);
      if (seq_item.dout != seq_item.dout_expected || seq_item.tx_valid != seq_item.tx_valid_expected) begin
        error_count++;
      end
      else begin
        correct_count++;
      end
    end

  endtask

  function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      $display("Final Counters for ram %d,%d", correct_count, error_count);
  endfunction
  
endclass 
endpackage