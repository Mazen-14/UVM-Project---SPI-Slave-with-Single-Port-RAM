package ram_seq_item_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_seq_item extends uvm_sequence_item;
`uvm_object_utils(ram_seq_item)

  rand logic [9:0] din;
  rand logic clk, rst_n, rx_valid;
  logic [7:0] dout, dout_expected;
  logic tx_valid, tx_valid_expected;
  op_t old_op;

  function new(string name = "ram_seq_item");
    super.new(name);
  endfunction

  constraint const_w {
    rst_n dist {0:=2 , 1:=98};
    rx_valid dist {0:=20 , 1:=80}; 
  }

  constraint wr_c {
    if(old_op == WRITE_ADDRESS)
    {
      din[9:8] inside {WRITE_ADDRESS, WRITE_DATA};
    }
  }

  constraint rd_c {
    if(old_op == READ_ADDRESS)
    {
      din[9:8] == READ_DATA;
    }
    else if(old_op == READ_DATA)
    {
      din[9:8] == READ_ADDRESS;
    }
  }

  constraint rd_wr {
    if(old_op == WRITE_ADDRESS)
    {
      din[9:8] inside {WRITE_ADDRESS, WRITE_DATA};
    }
    if(old_op == READ_ADDRESS)
    {
      din[9:8] == READ_DATA;
    }
    if(old_op == WRITE_DATA)
    {
      din[9:8] dist {READ_ADDRESS:/60, WRITE_ADDRESS:/40};
    }
    else if(old_op == READ_DATA)
    {
      din[9:8] dist {WRITE_ADDRESS:/60, READ_ADDRESS:/40};
    }
  }

  function void post_randomize;
    old_op = op_t'(din[9:8]);
  endfunction

  function string convert2string();
    return $sformatf("%s rst_n = 0b%0b, din = 0b%0b, rx_valid = 0b%0b, dout = 0b%0b, tx_valid = 0b%0b",
     super.convert2string(), rst_n, din, rx_valid, dout, tx_valid);
  endfunction

  function string convert2string_stimulus();
    return $sformatf("rst_n = 0b%0b, din = 0b%0b, rx_valid = 0b%0b",
    rst_n, din, rx_valid);
  endfunction
endclass
endpackage