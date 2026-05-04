import uvm_pkg::*;
import wrapper_test_pkg::*;
`include "uvm_macros.svh"
module top;
    bit clk;
    initial forever #1 clk=~clk;

    wrapper_IF w_vif(clk);
    spi_IF s_vif(clk);
    ram_IF r_vif(clk);
    
    // Wrapper
    WRAPPER W_DUT(w_vif.MOSI,w_vif.MISO,w_vif.SS_n,w_vif.clk,w_vif.rst_n);
    SPI_WRAPPER_GOLDEN W_GOLDEN(w_vif.MOSI,w_vif.MISO_ref,w_vif.SS_n,w_vif.clk,w_vif.rst_n);

    // SPI SLAVE
    assign s_vif.rx_data = W_DUT.rx_data_din;
    assign s_vif.rst_n = W_DUT.rst_n;
    assign s_vif.rx_valid = W_DUT.rx_valid;
    assign s_vif.tx_data = W_DUT.tx_data_dout;
    assign s_vif.tx_valid = W_DUT.tx_valid;
    assign s_vif.rx_data_ref = W_GOLDEN.rx_data;
    assign s_vif.rx_valid_ref = W_GOLDEN.rx_valid;
    assign s_vif.MISO_ref = W_GOLDEN.MISO;
    assign s_vif.MISO = W_DUT.MISO;
    assign s_vif.SS_n = W_DUT.SS_n;
    assign s_vif.MOSI = W_DUT.MOSI;

    // RAM
    assign r_vif.din = W_DUT.rx_data_din;
    assign r_vif.rst_n = W_DUT.rst_n;
    assign r_vif.rx_valid = W_DUT.rx_valid;
    assign r_vif.dout = W_DUT.tx_data_dout;
    assign r_vif.dout_expected = W_GOLDEN.tx_data;
    assign r_vif.tx_valid = W_DUT.tx_valid;
    assign r_vif.tx_valid_expected = W_GOLDEN.tx_valid;
    
    bind W_DUT wrapper_SVA wrapper_inst(w_vif.SVA);
    bind W_DUT.SLAVE_instance spi_SVA spi_inst(s_vif.SVA);
    bind W_DUT.RAM_instance ram_SVA ram_inst(r_vif.SVA);

    initial begin
        uvm_config_db#(virtual wrapper_IF) :: set(null,"uvm_test_top","W_IF",w_vif);
        uvm_config_db#(virtual spi_IF) :: set(null,"uvm_test_top","S_IF",s_vif);
        uvm_config_db#(virtual ram_IF) :: set(null,"uvm_test_top","R_IF",r_vif);
        run_test("wrapper_test");
    end
endmodule

