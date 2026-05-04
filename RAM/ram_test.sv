package ram_test_pkg;
import ram_env_pkg::*;
import ram_rst_seq_pkg::*;
import ram_write_only_seq_pkg::*;
import ram_read_only_seq_pkg::*;
import ram_write_read_seq_pkg::*;
import ram_config_obj_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_test extends uvm_test;
  `uvm_component_utils(ram_test)
  ram_env env;
  ram_config_obj ram_cfg;
  ram_rst_seq rst_seq;
  ram_write_only_seq wr_only_seq;
  ram_read_only_seq rd_only_seq;
  ram_write_read_seq wr_rd_seq;
  virtual ram_if ram_vif;

  function new(string name = "ram_test", uvm_component parent = null);
    super.new(name,parent);  
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ram_env::type_id::create("env",this);
    ram_cfg = ram_config_obj::type_id::create("ram_cfg");
    rst_seq = ram_rst_seq::type_id::create("rst_seq");
    wr_only_seq = ram_write_only_seq::type_id::create("wr_only_seq");
    rd_only_seq = ram_read_only_seq::type_id::create("rd_only_seq");
    wr_rd_seq = ram_write_read_seq::type_id::create("wr_rd_seq");
    ram_cfg.is_active = UVM_ACTIVE;
    if(!uvm_config_db #(virtual ram_if)::get(this, "", "ram_if", ram_cfg.ram_config_vif))
      `uvm_fatal("build_phase", "Test - unable to get the virtual interface of the ram from the uvm_config_db");
    uvm_config_db #(ram_config_obj)::set(this, "*", "CFG", ram_cfg);  
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //rst_sequence
    `uvm_info("run_phase", "reset asserted", UVM_LOW)
    rst_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "reset deasserted", UVM_LOW)
    
    //write_only_sequence
    `uvm_info("run_phase", "write only stimulus generation asserted", UVM_LOW)
    wr_only_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "write only stimulus generation deasserted", UVM_LOW)

    //read_only_sequence
    `uvm_info("run_phase", "read only stimulus generation asserted", UVM_LOW)
    rd_only_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "read only stimulus generation deasserted", UVM_LOW)

    //write_read_sequence
    `uvm_info("run_phase", "write read stimulus generation asserted", UVM_LOW)
    wr_rd_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "write read stimulus generation deasserted", UVM_LOW)
    
    phase.drop_objection(this);
  endtask
endclass
  
endpackage