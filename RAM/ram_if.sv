interface ram_IF(input bit clk);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
logic [9:0] din;
logic       rst_n, rx_valid;
logic [7:0] dout, dout_expected;
logic       tx_valid, tx_valid_expected;
  
modport SVA(input din, clk, rst_n, rx_valid, dout, tx_valid);
endinterface