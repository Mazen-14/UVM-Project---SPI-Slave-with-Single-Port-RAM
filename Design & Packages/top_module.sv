import ram_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top();
bit clk;
initial begin
  clk = 0;
  forever begin
    #1 clk = ~clk;
  end
end

ram_if r_if(clk);

RAM DUT(r_if.din, r_if.clk, r_if.rst_n, r_if.rx_valid, r_if.dout, r_if.tx_valid);

RAM_gmodel r_gmodel(r_if.clk, r_if.rst_n, r_if.rx_valid, r_if.din, r_if.tx_valid_expected, r_if.dout_expected);

bind RAM SVA sva(r_if.SVA);

initial begin
  uvm_config_db#(virtual ram_if)::set(null, "uvm_test_top", "ram_if", r_if);
  run_test("ram_test");
end

endmodule