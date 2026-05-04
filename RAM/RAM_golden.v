module RAM_gmodel(clk,rst_n,rx_valid,din,tx_valid,dout);

parameter MEM_WIDTH = 8;
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input clk,rst_n,rx_valid;
input [9:0] din;
output reg tx_valid;
output reg [7:0] dout; 
reg [ADDR_SIZE-1:0] wr_addr,rd_addr;

reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];

always@(posedge clk)begin
  if(!rst_n) begin dout<=0; tx_valid<=0; wr_addr<=0; rd_addr<=0; end
  else if(rx_valid) begin
    case(din[9:8])
    2'b00 : begin wr_addr <= din[7:0]; tx_valid<=0; end
    2'b01 : begin mem[wr_addr] <= din[7:0]; tx_valid<=0; end
    2'b10 : begin rd_addr <= din[7:0]; tx_valid<=0; end
    2'b11 : begin dout <= mem[rd_addr]; tx_valid<= 1; end
    endcase
  end
end
endmodule