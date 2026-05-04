module SPI_WRAPPER_GOLDEN(
    input MOSI,
    output MISO,
    input SS_n,
    input clk,
    input rst_n
);

    // Internal signals
    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;

    // SPI_SLAVE instantiation
    SPI_SLAVE spi_slave_inst (
        .clk(clk),
        .rst_n(rst_n),
        .SS_n(SS_n),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .MOSI(MOSI),
        .MISO(MISO)
    );

    // RAM instantiation
    RAM ram_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx_valid(rx_valid),
        .din(rx_data),
        .tx_valid(tx_valid),
        .dout(tx_data)
    );

endmodule