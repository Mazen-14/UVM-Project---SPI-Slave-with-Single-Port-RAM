package spi_agent_pkg;
import uvm_pkg::*;
import spi_driver_pkg::*;
import spi_monitor_pkg::*;
import config_obj_pkg::*;
import spi_sequencer_pkg::*;
import spi_sequence_item_pkg::*;
`include "uvm_macros.svh"
class spi_agent extends uvm_agent;
    `uvm_component_utils(spi_agent)
    config_obj cfg;
    spi_driver drv;
    spi_monitor mon;
    spi_sequencer sqr;
    uvm_analysis_port #(spi_seq_item) agt_ap;
    
    function new(string name = "spi_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(config_obj)::get(this,"","S_CFG",cfg))
            `uvm_fatal("build phase","error")
        if(cfg.is_active == UVM_ACTIVE)begin
            sqr = spi_sequencer::type_id::create("sqr",this);
            drv = spi_driver::type_id::create("drv",this);
        end
        mon = spi_monitor::type_id::create("mon",this);
        agt_ap = new("agt_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(cfg.is_active == UVM_ACTIVE)begin
            drv.spi_driver_vif = cfg.spi_config_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
        mon.v_if = cfg.spi_config_vif;
        mon.mon_ap.connect(agt_ap);
    endfunction

endclass
endpackage