package ram_coverage_pkg;
import ram_seq_item_pkg::*;
import uvm_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"
class ram_coverage extends uvm_component;
`uvm_component_utils(ram_coverage)
  uvm_analysis_export #(ram_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
  ram_seq_item seq_item;
  logic [9:0] din;
  logic tx_valid, rx_valid;

  covergroup Covram;

    din_cp : coverpoint din[9:8] {
      bins write_addr = {2'b00};
      bins write_data = {2'b01};
      bins read_addr = {2'b10};
      bins read_data = {2'b11};
    }

    wr_data_after_wr_addr : coverpoint din[9:8] iff(rx_valid){
      bins wr_data_wr_addr = (2'b00 => 2'b01);
    }

    rd_data_after_rd_addr : coverpoint din[9:8] iff(rx_valid){
      bins rd_data_rd_addr = (2'b10 => 2'b11);
    }

    cross_din_rx : cross din_cp, rx_valid {
      option.cross_auto_bin_max =0;
      bins din_rx = binsof(din_cp) && binsof(rx_valid) intersect {1'b1};
    }

    cross_read_tx : cross din_cp, tx_valid {
      option.cross_auto_bin_max =0;
      bins rd_tx = binsof(din_cp.read_data) && binsof(tx_valid) intersect {1'b1};
    }
    
  endgroup

  function new(string name = "ram_coverage", uvm_component parent = null);
    super.new(name,parent);
    Covram = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
  endfunction
    
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_fifo.get(seq_item);
      din = seq_item.din;
      rx_valid = seq_item.rx_valid;
      tx_valid = seq_item.tx_valid;

      if (seq_item.rst_n) begin
        Covram.sample();
      end
    end
  endtask
endclass
endpackage