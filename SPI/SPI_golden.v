module SPI_SLAVE(clk,rst_n,SS_n,rx_data,rx_valid,tx_data,tx_valid,MOSI,MISO);
parameter IDLE = 3'b000;
parameter CHK_CMD = 3'b001;
parameter WRITE = 3'b010;
parameter READ_ADD = 3'b011;
parameter READ_DATA = 3'b100;


input clk,rst_n,SS_n,MOSI,tx_valid;
input [7:0] tx_data;
output reg MISO ,rx_valid;
output reg [9:0] rx_data;
(* fsm_encoding = "sequential" *)
reg [2:0] cs,ns;
reg read_state;  
reg [4:0] counter;

// STATE MEMORY
always@(posedge clk)begin
    if(!rst_n) begin cs <= IDLE; read_state <= 0; end 
    else begin
        cs <= ns;
            
    end
end

// NEXT STATE
always@(cs,SS_n,MOSI)begin
    case(cs)                                
    IDLE : begin
        if(SS_n) ns=IDLE;
        else ns=CHK_CMD;
    end
    CHK_CMD : begin
        if(SS_n) ns=IDLE;
        else begin
            if(!MOSI) ns=WRITE;
            else if(!read_state) ns=READ_ADD;
            else ns=READ_DATA; 
        end
    end
    WRITE : begin
        if(SS_n) ns=IDLE;
        else ns=WRITE;
    end
    READ_ADD : begin
        if(SS_n) ns=IDLE;
        else ns=READ_ADD;
    end
    READ_DATA : begin
        if(SS_n) ns=IDLE;
        else ns=READ_DATA;
    end
    default : ns = IDLE;
    endcase
end

// OUTPUT LOGIC
always@(posedge clk)begin
    if (!rst_n) begin
        rx_valid <= 0;
        counter <= 0;
        MISO <= 0;
        rx_data <=0;
    end else begin
    case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    read_state <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        read_state <= 0;
                        counter<=10;
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
    endcase
    end
end
endmodule