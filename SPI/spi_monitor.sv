package spi_monitor_pkg;
import uvm_pkg::*;
import spi_sequence_item_pkg::*;
`include "uvm_macros.svh"
class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)
    virtual spi_IF v_if;
    spi_seq_item seq_item;
    uvm_analysis_port #(spi_seq_item) mon_ap;
    
    function new(string name = "spi_monitor",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = spi_seq_item::type_id::create("seq_item");
            seq_item.MOSI      = v_if.MOSI;
            seq_item.rst_n     = v_if.rst_n;
            seq_item.SS_n      = v_if.SS_n;
            seq_item.tx_valid  = v_if.tx_valid;
            seq_item.tx_data   = v_if.tx_data;
            seq_item.rx_data   = v_if.rx_data;
            seq_item.rx_valid  = v_if.rx_valid;
            seq_item.MISO      = v_if.MISO;
            seq_item.rx_data_ref   = v_if.rx_data_ref;
            seq_item.rx_valid_ref  = v_if.rx_valid_ref;
            seq_item.MISO_ref      = v_if.MISO_ref;
            @(negedge v_if.clk);
            mon_ap.write(seq_item);
        end
    endtask
endclass
endpackage