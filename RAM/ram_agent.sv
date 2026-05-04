package ram_agent_pkg;
import ram_driver_pkg::*;
import ram_sequencer_pkg::*;
import ram_monitor_pkg::*;
import ram_config_obj_pkg::*;
import ram_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent)
  ram_driver driver;
  ram_sequencer sqr;
  ram_monitor mon;
  ram_config_obj ram_cfg;
  uvm_analysis_port #(ram_seq_item) agt_ap;

  function new(string name = "ram_agent" , uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = ram_monitor::type_id::create("mon",this);
    if(!uvm_config_db#(ram_config_obj)::get(this, "", "R_CFG", ram_cfg))
      `uvm_fatal("build_phase", "agent - unable to get the config object");
    if(ram_cfg.is_active == UVM_ACTIVE)begin
      driver = ram_driver::type_id::create("driver",this);
      sqr = ram_sequencer::type_id::create("sqr",this);
    end
    agt_ap = new("agt_ap", this);
    
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(ram_cfg.is_active == UVM_ACTIVE)begin
      driver.ram_driver_vif = ram_cfg.ram_config_vif;
      driver.seq_item_port.connect(sqr.seq_item_export);
    end
    mon.ram_monitor_vif = ram_cfg.ram_config_vif;
    mon.mon_ap.connect(agt_ap);
  endfunction

endclass

endpackage