interface spi_IF(input clk);

    logic        MOSI;
    logic        rst_n;
    logic        SS_n;
    logic        tx_valid;
    logic [7:0]  tx_data;
    logic [9:0]  rx_data;
    logic        rx_valid;
    logic        MISO;
    logic [9:0]  rx_data_ref;
    logic        rx_valid_ref;
    logic        MISO_ref;

    modport DUT (input  MOSI, clk, rst_n, SS_n, tx_valid, tx_data,output rx_data, rx_valid, MISO);
    modport SVA (input  MOSI, clk, rst_n, SS_n, tx_valid, tx_data,rx_data, rx_valid, MISO);
endinterface