package wrapper_sequence_item_pkg;
import uvm_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"
class wrapper_seq_item extends uvm_sequence_item;
    `uvm_object_utils(wrapper_seq_item)
    rand logic rst_n;
    logic MOSI,SS_n,MISO,MISO_ref;
    rand bit [10:0] MOSI_bits;
    bit [10:0] MOSI_bits_old;
    static integer counter = 0;
    static integer bit_index = 10;
    static bit new_frame_needed = 1;
    op_t old_op;

    constraint rst_constrain {
        rst_n dist{0:=2,1:=98};
    }


    constraint mosi_constrain {
        MOSI_bits[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
    }

    constraint wr_c {
        if(old_op == WRITE_ADDRESS)
        {
          MOSI_bits[10:8] inside {3'b000, 3'b001};
        }
    }

    constraint rd_c {
        if(old_op == READ_ADDRESS)
        {
          MOSI_bits[10:8] == 3'b111;
        }
        else if(old_op == READ_DATA)
        {
          MOSI_bits[10:8] == 3'b110;
        }
    }

    constraint rd_wr {
        if(old_op == WRITE_ADDRESS)
        {
          MOSI_bits[10:8] inside {3'b000, 3'b001};
        }
        if(old_op == READ_ADDRESS)
        {
          MOSI_bits[10:8] == 3'b111;
        }
        if(old_op == WRITE_DATA)
        {
          MOSI_bits[10:8] dist {3'b110:/60, 3'b000:/40};
        }
        else if(old_op == READ_DATA)
        {
          MOSI_bits[10:8] dist {3'b000:/60, 3'b110:/40};
        }
    }

    
    function new(string name = "wrapper_seq_item");
        super.new(name);
    endfunction
    function void pre_randomize();
        if(!rst_n)begin
            if(old_op == READ_DATA) old_op = READ_ADDRESS;
            else if(old_op == READ_ADDRESS) old_op = READ_DATA;
        end
    endfunction
    function void post_randomize();
        if(!rst_n)begin
            counter = 0;
            SS_n=1;
            new_frame_needed = 1;
            bit_index = 10;
        end
        else begin
            counter++;
            if (new_frame_needed) begin
                MOSI_bits_old = MOSI_bits;
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
                if (counter == 23)begin
                    SS_n = 1;
                    counter = 0;
                    new_frame_needed = 1;
                end
                else begin
                    SS_n = 0;
                end
            end 
            else begin
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
        old_op = op_t'(MOSI_bits_old[9:8]);
    endfunction

    function string convert2string();
        return $sformatf(
            "Cycle=%0d | rst_n=%0b | SS_n=%0b | MOSI=%0b | MISO=%0b | MOSI_bits=%b",
            counter, rst_n, SS_n, MOSI, MISO, MOSI_bits);
    endfunction

    function string convert2string_stimulus();
        return $sformatf(
            "Cycle=%0d | rst_n=%0b | SS_n=%0b | MOSI=%0b",
            counter, rst_n, SS_n, MOSI);
    endfunction

endclass
endpackage

