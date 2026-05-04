module spi_SVA(spi_IF.SVA s_vif);

    property rst_prp;
        @(posedge s_vif.clk) !s_vif.rst_n |=> (!s_vif.MISO && !s_vif.rx_valid && ~s_vif.rx_data); 
    endproperty
    assert1 : assert property(rst_prp);
    cover1 : cover property(rst_prp);

    sequence write_addr_sequence;
        s_vif.SS_n ##2 !s_vif.MOSI ##1 !s_vif.MOSI ##1 !s_vif.MOSI;
    endsequence
    sequence write_data_sequence;
        s_vif.SS_n ##1 !s_vif.MOSI ##1 !s_vif.MOSI ##1 s_vif.MOSI;
    endsequence
    sequence read_addr_sequence;
        s_vif.SS_n ##1 s_vif.MOSI ##1 s_vif.MOSI ##1 !s_vif.MOSI;
    endsequence
    sequence read_data_sequence;
        s_vif.SS_n ##1 s_vif.MOSI ##1 s_vif.MOSI ##1 s_vif.MOSI;
    endsequence
    sequence rx_ssn_sequence;
        ##10 s_vif.rx_valid && s_vif.SS_n[->1];
    endsequence
    property valid_sequence;
        @(posedge s_vif.clk) disable iff(!s_vif.rst_n)  
        ((write_addr_sequence) or (write_data_sequence) or (read_addr_sequence) or (read_data_sequence) |-> rx_ssn_sequence);
    endproperty
    assert2 : assert property(valid_sequence);
    cover2 : cover property(valid_sequence);

endmodule