package ram_monitor_pkg;
import ram_seq_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_monitor extends uvm_monitor;
  `uvm_component_utils(ram_monitor)
  virtual ram_IF ram_monitor_vif;
  ram_seq_item seq_item;
  uvm_analysis_port #(ram_seq_item) mon_ap;

  function new(string name = "ram_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item = ram_seq_item::type_id::create("seq_item");
      @(negedge ram_monitor_vif.clk);
      seq_item.rst_n = ram_monitor_vif.rst_n;
      seq_item.din = ram_monitor_vif.din;
      seq_item.rx_valid = ram_monitor_vif.rx_valid;
      seq_item.dout = ram_monitor_vif.dout;
      seq_item.dout_expected = ram_monitor_vif.dout_expected;
      seq_item.tx_valid = ram_monitor_vif.tx_valid;
      seq_item.tx_valid_expected = ram_monitor_vif.tx_valid_expected;
      mon_ap.write(seq_item);
      `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH)
    end
  endtask
endclass

endpackage