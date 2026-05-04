package spi_test_pkg;
    import uvm_pkg::*;
    import spi_env_pkg::*;
    import spi_main_sequence_pkg::*;
    import spi_reset_sequence_pkg::*;
    import config_obj_pkg::*;
    `include "uvm_macros.svh"

    class spi_test extends uvm_test;
        `uvm_component_utils(spi_test)
        spi_env env;
        config_obj cfg;
        spi_main_sequence main_seq;
        spi_reset_sequence rst_seq;
        virtual spi_IF v_if;
       
        function new(string name = "spi_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = spi_env ::type_id:: create("env",this);
            cfg = config_obj::type_id::create("cfg");
            main_seq = spi_main_sequence::type_id::create("main_seq");
            rst_seq = spi_reset_sequence::type_id::create("rst_seq");
            if(!uvm_config_db#(virtual spi_IF)::get(this,"","V_IF",cfg.spi_config_vif))
                `uvm_fatal("build phase","error")
            uvm_config_db#(config_obj)::set(this,"*","CFG",cfg);
            cfg.is_active = UVM_ACTIVE;
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","Reset Sequence Start",UVM_MEDIUM);
            rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Reset Sequence End",UVM_MEDIUM);
            `uvm_info("run_phase","Main Sequence Start",UVM_MEDIUM);
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Main Sequence End",UVM_MEDIUM);
            phase.drop_objection(this);
        endtask

    endclass
endpackage
