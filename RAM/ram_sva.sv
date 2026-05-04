module ram_SVA(ram_IF.SVA r_vif);
  //reset
  property preset;
    @(posedge r_vif.clk) !r_vif.rst_n |=> (r_vif.dout == 0 && r_vif.tx_valid == 0); 
  endproperty
  areset : assert property (preset)
    else $error("Assertion areset failed! at time (%0t)" ,$time);
  creset : cover property(preset);

  // low tx_valid
  property ptx_valid_l;
    @(posedge r_vif.clk) disable iff(!r_vif.rst_n) (r_vif.din[9:8] == 2'b00 || r_vif.din[9:8] == 2'b01 || r_vif.din[9:8] == 2'b10) && (r_vif.rx_valid == 1'b1) |=> r_vif.tx_valid == 0 ; 
  endproperty
  atx_valid_l : assert property (ptx_valid_l)
    else $error("Assertion ptx_valid_l failed! at time (%0t)" ,$time);
  ctx_valid_l : cover property(ptx_valid_l);

  // high tx_valid
  property ptx_valid_h;
    @(posedge r_vif.clk) disable iff(!r_vif.rst_n) (r_vif.din[9:8] == 2'b11) && (r_vif.rx_valid == 1'b1) |=> $rose(r_vif.tx_valid) ##1 $fell(r_vif.tx_valid); 
  endproperty
  atx_valid_h : assert property (ptx_valid_h)
    else $error("Assertion ptx_valid_h failed! at time (%0t)" ,$time);
  ctx_valid_h : cover property(ptx_valid_h);

  //wr_addr => wr_data
  property pwr_addr_data;
    @(posedge r_vif.clk) disable iff(!r_vif.rst_n) (r_vif.din[9:8] == 2'b00) |-> ##[1:$] (r_vif.din[9:8] == 2'b01) ; 
  endproperty
  awr_addr_data : assert property (pwr_addr_data)
    else $error("Assertion pwr_addr_data failed! at time (%0t)" ,$time);
  cwr_addr_data : cover property(pwr_addr_data);

  //rd_addr => rd_data
  property prd_addr_data;
    @(posedge r_vif.clk) disable iff(!r_vif.rst_n) (r_vif.din[9:8] == 2'b10) |-> ##[1:$] (r_vif.din[9:8] == 2'b11) ; 
  endproperty
  ard_addr_data : assert property (prd_addr_data)
    else $error("Assertion prd_addr_data failed! at time (%0t)" ,$time);
  crd_addr_data : cover property(prd_addr_data);
  
 
endmodule