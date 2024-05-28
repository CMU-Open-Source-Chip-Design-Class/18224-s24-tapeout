`default_nettype none

// I/O Test Design
module my_chip (
    input logic [11:0] io_in, 
    input logic clock, reset,
    output logic [11:0] io_out
);

    logic [3:0] idx;
    logic [11:0] shift_bit;
    assign shift_bit = (idx == 0) ? 0 : (1 << (idx-1));

    // Shift the bit forward once per cycle
    always_ff @(posedge clock) begin
        if (reset) idx <= 0;
        else if (idx == 11) idx <= 0;
        else idx <= idx + 1;
    end

    assign io_out[0] = shift_bit[0] ^ (^(io_in & 12'b000000000000));
    assign io_out[1] = shift_bit[1] ^ (^(io_in & 12'b111111111111));

    assign io_out[2] = shift_bit[2] ^ (^(io_in & 12'b101010101010));
    assign io_out[3] = shift_bit[3] ^ (^(io_in & 12'b010101010101));

    assign io_out[4] = shift_bit[4] ^ (^(io_in & 12'b110011001100));
    assign io_out[5] = shift_bit[5] ^ (^(io_in & 12'b001100110011));

    assign io_out[6] = shift_bit[6] ^ (^(io_in & 12'b111100001111));
    assign io_out[7] = shift_bit[7] ^ (^(io_in & 12'b000011110000));

    assign io_out[8] = shift_bit[8] ^ (^(io_in & 12'b111111000000));
    assign io_out[9] = shift_bit[9] ^ (^(io_in & 12'b000000111111));

    assign io_out[10] = shift_bit[10] ^ (^(io_in & 12'b111100000000));
    assign io_out[11] = shift_bit[11] ^ (^(io_in & 12'b000011110000));


endmodule
