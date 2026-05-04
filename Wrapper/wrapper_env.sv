package wrapper_env_pkg;
import uvm_pkg::*;
import wrapper_agent_pkg::*;
import wrapper_scoreboard_pkg::*;
import wrapper_cvr_pkg::*;
import wrapper_sequence_item_pkg::*;
`include "uvm_macros.svh"
class wrapper_env extends uvm_env;
    `uvm_component_utils(wrapper_env)
    wrapper_agent agt;
    wrapper_scoreboard sb;
    wrapper_coveragecollector cvr;
    wrapper_seq_item seq_item;
  function new(string name = "wrapper_env",uvm_component parent = null);
      super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = wrapper_agent::type_id::create("agent",this);
    sb = wrapper_scoreboard::type_id::create("sb",this);
    cvr = wrapper_coveragecollector::type_id::create("cvr",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.agt_ap.connect(sb.sb_export);
    agt.agt_ap.connect(cvr.cvr_export);
  endfunction
endclass
endpackage