package spi_cvr_pkg;
import uvm_pkg::*;
import spi_sequence_item_pkg::*;
`include "uvm_macros.svh"
class spi_coveragecollector extends uvm_component;
    `uvm_component_utils(spi_coveragecollector)
    spi_seq_item seq_item;
    uvm_analysis_export #(spi_seq_item) cvr_export;
    uvm_tlm_analysis_fifo #(spi_seq_item) cvr_fifo;
    covergroup cvr_grp;
        rx_cp : coverpoint seq_item.rx_data[9:8]{
            bins write_addr  = {2'b00};
            bins write_data  = {2'b01};
            bins read_addr   = {2'b10};
            bins read_data   = {2'b11};
            bins transitions[] = (2'b00, 2'b01, 2'b10, 2'b11 => 2'b00, 2'b01, 2'b10, 2'b11);
            // Due to grey encoding 2 bits can't change at same time so these transitions will never happens 
            ignore_bins illegal_transitions_2[] = (2'b10=> 2'b01);
            ignore_bins illegal_transitions_3[] = (2'b01=> 2'b10);
            ignore_bins illegal_transitions_4[] = (2'b00 => 2'b11);
        }

        SSn_cp : coverpoint seq_item.SS_n {
            bins normal_transaction  = (1 => 0[*13] => 1);
            bins extended_transaction = (1 => 0[*22] => 1);
        }
        
        MOSI_cp : coverpoint seq_item.MOSI{
            bins write_addr[] = (0 => 0 => 0);
            bins write_data[] = (0 => 0 => 1);
            bins read_addr[] = (1 => 1 => 0);
            bins read_data[] = (1 => 1 => 1);
        }
        
        // x_SS_MOSI : cross SSn_cp, MOSI_cp{
        //     ignore_bins extended_000 = binsof(MOSI_cp.write_addr) && binsof(SSn_cp.extended_transaction);
        //     ignore_bins extended_001 = binsof(MOSI_cp.write_data) && binsof(SSn_cp.extended_transaction);
        //     ignore_bins extended_110 = binsof(MOSI_cp.read_addr) && binsof(SSn_cp.extended_transaction);
        //     ignore_bins normal_111 = binsof(MOSI_cp.read_data) && binsof(SSn_cp.normal_transaction);
        // }
    endgroup
    function new(string name = "spi_coveragecollector",uvm_component parent = null);
        super.new(name,parent);
        cvr_grp = new();
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
            cvr_grp.sample();
        end
    endtask
endclass
endpackage