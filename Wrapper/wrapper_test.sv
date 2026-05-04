package wrapper_test_pkg;
    import uvm_pkg::*;
    import wrapper_env_pkg::*;
    import wrapper_rst_sequence_pkg::*;
    import wrapper_write_only_sequence_pkg::*;
    import wrapper_read_only_sequence_pkg::*;
    import wrapper_write_read_sequence_pkg::*;
    import config_obj_pkg::*;
    import ram_config_obj_pkg::*;
    import wrapper_config_obj_pkg::*;
    import spi_env_pkg::*;
    import ram_env_pkg::*;
    import wrapper_env_pkg::*;
    `include "uvm_macros.svh"

    class wrapper_test extends uvm_test;
        `uvm_component_utils(wrapper_test)
        spi_env s_env;
        ram_env r_env;
        wrapper_env w_env;
        config_obj s_cfg;
        ram_config_obj r_cfg;
        wrapper_config_obj w_cfg;
        wrapper_rst_seq rst_seq;
        wrapper_write_only_seq wr_only_seq;
        wrapper_read_only_seq rd_only_seq;
        wrapper_write_read_seq wr_rd_seq;
        virtual spi_IF s_if;
        virtual ram_IF r_if;
        virtual wrapper_IF w_if;
       
        function new(string name = "wrapper_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            s_env = spi_env ::type_id:: create("s_env",this);
            r_env = ram_env ::type_id:: create("r_env",this);
            w_env = wrapper_env ::type_id:: create("w_env",this);

            s_cfg = config_obj::type_id::create("s_cfg");
            r_cfg = ram_config_obj::type_id::create("r_cfg");
            w_cfg = wrapper_config_obj::type_id::create("w_cfg");

            rst_seq = wrapper_rst_seq::type_id::create("rst_seq");
            wr_only_seq = wrapper_write_only_seq::type_id::create("wr_only_seq");
            rd_only_seq = wrapper_read_only_seq::type_id::create("rd_only_seq");
            wr_rd_seq = wrapper_write_read_seq::type_id::create("wr_rd_seq");

            if(!uvm_config_db#(virtual spi_IF)::get(this,"","S_IF",s_cfg.spi_config_vif))
                `uvm_fatal("build phase","error")
            if(!uvm_config_db#(virtual ram_IF)::get(this,"","R_IF",r_cfg.ram_config_vif))
                `uvm_fatal("build phase","error")
            if(!uvm_config_db#(virtual wrapper_IF)::get(this,"","W_IF",w_cfg.wrapper_config_vif))
                `uvm_fatal("build phase","error")

            s_cfg.is_active = UVM_PASSIVE;
            r_cfg.is_active = UVM_PASSIVE;
            w_cfg.is_active = UVM_ACTIVE;

            uvm_config_db#(config_obj)::set(this,"*","S_CFG",s_cfg);
            uvm_config_db#(ram_config_obj)::set(this,"*","R_CFG",r_cfg);
            uvm_config_db#(wrapper_config_obj)::set(this,"*","W_CFG",w_cfg);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            //rst_sequence
            `uvm_info("run_phase", "reset asserted", UVM_LOW)
            rst_seq.start(w_env.agt.sqr);
            `uvm_info("run_phase", "reset deasserted", UVM_LOW)

            //write_only_sequence
            `uvm_info("run_phase", "write only stimulus generation asserted", UVM_LOW)
            wr_only_seq.start(w_env.agt.sqr);
            `uvm_info("run_phase", "write only stimulus generation deasserted", UVM_LOW)

            //read_only_sequence
            `uvm_info("run_phase", "read only stimulus generation asserted", UVM_LOW)
            rd_only_seq.start(w_env.agt.sqr);
            `uvm_info("run_phase", "read only stimulus generation deasserted", UVM_LOW)

            //write_read_sequence
            `uvm_info("run_phase", "write read stimulus generation asserted", UVM_LOW)
            wr_rd_seq.start(w_env.agt.sqr);
            `uvm_info("run_phase", "write read stimulus generation deasserted", UVM_LOW)

            phase.drop_objection(this);
        endtask

    endclass
endpackage
