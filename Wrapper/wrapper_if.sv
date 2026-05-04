interface wrapper_IF(input clk);

    logic  MOSI, SS_n, rst_n, MISO, MISO_ref;

    modport DUT (input  MOSI, clk, rst_n, SS_n, output MISO);
    modport SVA (input  MOSI, clk, rst_n, SS_n, MISO);
endinterface