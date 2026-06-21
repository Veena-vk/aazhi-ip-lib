/*
 * debounce.v — Button / Signal Debouncer
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Waits for the input to be stable for STABLE_COUNT clock cycles
 * before updating the output.
 *
 * Parameters:
 *   STABLE_COUNT — number of stable cycles required (default 1000)
 *
 * Ports:
 *   clk       — system clock
 *   rst       — synchronous reset
 *   noisy_in  — raw (bouncy) input
 *   clean_out — debounced output
 */
`timescale 1ns / 1ps
module debounce #(parameter STABLE_COUNT = 1000)(
    input  wire clk,
    input  wire rst,
    input  wire noisy_in,
    output reg  clean_out
);
    reg [$clog2(STABLE_COUNT):0] cnt = 0;
    reg prev = 0;

    always @(posedge clk) begin
        if (rst) begin cnt <= 0; prev <= 0; clean_out <= 0; end
        else begin
            if (noisy_in == prev) begin
                if (cnt == STABLE_COUNT) begin
                    clean_out <= noisy_in; cnt <= 0;
                end else cnt <= cnt + 1;
            end else begin cnt <= 0; prev <= noisy_in; end
        end
    end
endmodule
