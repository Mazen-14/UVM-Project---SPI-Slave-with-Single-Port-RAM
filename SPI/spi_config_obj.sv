package config_obj_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class config_obj extends uvm_object;
    `uvm_object_utils(config_obj)
    virtual spi_IF spi_config_vif;
    uvm_active_passive_enum is_active;

    function new(string name = "config_obj");
        super.new(name);
    endfunction
endclass
endpackage