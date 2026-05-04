module wrapper_SVA(wrapper_IF.SVA w_vif);

    property rst_prp;
        @(posedge w_vif.clk) !w_vif.rst_n |=> (!w_vif.MISO); 
    endproperty
    assert1 : assert property(rst_prp);
    cover1 : cover property(rst_prp);

    sequence write_addr_sequence;
        w_vif.SS_n ##2 !w_vif.MOSI ##1 !w_vif.MOSI ##1 !w_vif.MOSI;
    endsequence
    sequence write_data_sequence;
        w_vif.SS_n ##2 !w_vif.MOSI ##1 !w_vif.MOSI ##1 w_vif.MOSI;
    endsequence
    sequence read_addr_sequence;
        w_vif.SS_n ##2 w_vif.MOSI ##1 w_vif.MOSI ##1 !w_vif.MOSI;
    endsequence


    property miso_stable;
    @(posedge w_vif.clk) disable iff(!w_vif.rst_n)
        (write_addr_sequence or write_data_sequence or read_addr_sequence) |-> $stable(w_vif.MISO);
    endproperty
    assert2 : assert property(miso_stable);
    cover2 : cover property(miso_stable);

endmodule