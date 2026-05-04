package spi_env_pkg;
import uvm_pkg::*;
import spi_agent_pkg::*;
import spi_scoreboard_pkg::*;
import spi_cvr_pkg::*;
import spi_sequence_item_pkg::*;
`include "uvm_macros.svh"
class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)
    spi_agent agt;
    spi_scoreboard sb;
    spi_coveragecollector cvr;
    spi_seq_item seq_item;
  function new(string name = "spi_env",uvm_component parent = null);
      super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = spi_agent::type_id::create("agent",this);
    sb = spi_scoreboard::type_id::create("sb",this);
    cvr = spi_coveragecollector::type_id::create("cvr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.agt_ap.connect(sb.sb_export);
    agt.agt_ap.connect(cvr.cvr_export);
  endfunction
endclass
endpackage