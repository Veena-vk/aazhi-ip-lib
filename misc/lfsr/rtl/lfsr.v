/*
 * lfsr.v — Linear Feedback Shift Register (Galois form, maximal-length)
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Generates a pseudo-random bit/word sequence. Taps are chosen for
 * maximal length (2^WIDTH - 1 period) for common widths 8, 16, 32.
 *
 * Parameters:
 *   WIDTH — shift register width (8, 16, or 32; default 16)
 *   SEED  — initial value (must be non-zero, default 1)
 *
 * Ports:
 *   clk     — clock
 *   rst     — synchronous reset to SEED
 *   en      — shift enable
 *   rnd_out — current LFSR state (WIDTH-bit pseudo-random word)
 *   bit_out — LSB of LFSR state
 */
`timescale 1ns / 1ps
module lfsr #(
    parameter WIDTH = 16,
    parameter SEED  = 1
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             en,
    output wire [WIDTH-1:0] rnd_out,
    output wire             bit_out
);
    reg [WIDTH-1:0] state = SEED;

    // Maximal-length taps (Galois form XOR masks)
    // WIDTH 8  : x^8 + x^6 + x^5 + x^4 + 1   → 0xB8
    // WIDTH 16 : x^16 + x^15 + x^13 + x^4 + 1 → 0xB400
    // WIDTH 32 : x^32 + x^22 + x^2  + x^1 + 1 → 0xB4BCD35C
    function [WIDTH-1:0] taps;
        input integer w;
        begin
            case (w)
                8:  taps = 8'hB8;
                16: taps = 16'hB400;
                32: taps = 32'hB4BCD35C;
                default: taps = {WIDTH{1'b0}};  // user must supply taps
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (rst) state <= SEED;
        else if (en)
            state <= {1'b0, state[WIDTH-1:1]} ^ (state[0] ? taps(WIDTH) : {WIDTH{1'b0}});
    end

    assign rnd_out = state;
    assign bit_out = state[0];
endmodule
