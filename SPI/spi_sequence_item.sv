package spi_sequence_item_pkg;
import uvm_pkg::*;
localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;
`include "uvm_macros.svh"
class spi_seq_item extends uvm_sequence_item;
    `uvm_object_utils(spi_seq_item)
    rand logic rst_n;
    logic MOSI,tx_valid,SS_n;
    logic rx_valid,MISO,rx_valid_ref,MISO_ref;
    rand logic [7:0] tx_data;
    logic [7:0] tx_data_old;
    logic [9:0] rx_data,rx_data_ref;
    rand bit [10:0] MOSI_bits;
    bit [10:0] MOSI_bits_old;
    static integer counter = 0;
    static integer bit_index = 10;
    static bit new_frame_needed = 1;
    static logic received_address = 1;

    constraint rst_constrain{
        rst_n dist{0:=2,1:=98};
    }
    constraint mosi_constrain{
        MOSI_bits[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
    }
    
    function new(string name = "spi_seq_item");
        super.new(name);
    endfunction

    function void post_randomize();
        if(!rst_n)begin
            counter = 0;
            SS_n=1;
            new_frame_needed = 1;
            bit_index = 10;
            tx_valid = 0;
            received_address = 1;
        end
        else begin
            counter++;
            if (new_frame_needed) begin
                MOSI_bits_old = MOSI_bits;
                tx_data_old = tx_data;
                bit_index = 10;
                new_frame_needed = 0;
            end

            if(counter>=2)begin
                MOSI = MOSI_bits_old[bit_index];
                bit_index--;
            end
            if (bit_index < 0) begin
                bit_index = 10;
            end
            if (MOSI_bits_old[9:8] == 2'b11) begin
                if(counter == 14)tx_valid = 1;
                else if (counter == 23)begin
                    SS_n = 1;
                    counter = 0;
                    new_frame_needed = 1;
                    tx_valid = 0;
                end
                else begin
                    SS_n = 0;
                end
            end 
            else begin
                tx_valid = 0;
                if (counter == 14)begin
                    SS_n = 1;
                    counter = 0;
                    new_frame_needed = 1;
                end
                else begin
                    SS_n = 0;
                end
            end
        end
    endfunction

    function string convert2string();
        return $sformatf(
            "Cycle=%0d | rst_n=%0b | SS_n=%0b | MOSI=%0b | MISO=%0b | tx_valid=%0b | rx_valid=%0b | tx_data=0x%0h | rx_data=0x%0h | MOSI_bits=%b",
            counter, rst_n, SS_n, MOSI, MISO, tx_valid, rx_valid, tx_data_old, rx_data, MOSI_bits
    );
    endfunction

    function string convert2string_stimulus();
        return $sformatf(
            "Cycle=%0d | rst_n=%0b | SS_n=%0b | tx_valid=%0b | rx_valid=%0b | MOSI_bits=%b | tx_data=0x%0h | rx_data=0x%0h",
            counter, rst_n, SS_n, tx_valid, rx_valid, MOSI_bits, tx_data_old, rx_data
        );
    endfunction

endclass
endpackage

