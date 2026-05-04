package spi_driver_pkg;
import uvm_pkg::*;
import spi_sequence_item_pkg::*;
`include "uvm_macros.svh"
class spi_driver extends uvm_driver#(spi_seq_item);
    `uvm_component_utils(spi_driver)
    virtual spi_IF spi_driver_vif;
    spi_seq_item seq_item;

    function new(string name = "spi_driver",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = spi_seq_item :: type_id:: create("seq_item");
            seq_item_port.get_next_item(seq_item);
            spi_driver_vif.MOSI      = seq_item.MOSI;
            spi_driver_vif.rst_n     = seq_item.rst_n;
            spi_driver_vif.SS_n      = seq_item.SS_n;
            spi_driver_vif.tx_valid  = seq_item.tx_valid;
            spi_driver_vif.tx_data   = seq_item.tx_data_old;  
            seq_item.rx_data         = spi_driver_vif.rx_data;     
            @(negedge spi_driver_vif.clk);
            seq_item_port.item_done();
            `uvm_info("run_phase",seq_item.convert2string_stimulus(),UVM_HIGH);
        end
    endtask

endclass
endpackage
