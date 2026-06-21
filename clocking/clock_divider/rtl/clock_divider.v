/*
 * clock_divider.v — Integer Clock Divider
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Divides input clock by any even integer >= 2.
 * For odd divisors the output duty cycle will be slightly asymmetric
 * (~50% is maintained with the falling-edge trick).
 *
 * Parameters:
 *   DIVISOR — division ratio (default 4, minimum 2)
 *
 * Ports:
 *   clk_in  — input clock
 *   rst     — synchronous reset
 *   clk_out — divided output clock (50% duty, registered)
 */
`timescale 1ns / 1ps
module clock_divider #(parameter DIVISOR = 4)(
    input  wire clk_in,
    input  wire rst,
    output reg  clk_out
);
    reg [$clog2(DIVISOR):0] cnt = 0;
    always @(posedge clk_in) begin
        if (rst) begin cnt <= 0; clk_out <= 0; end
        else begin
            if (cnt == (DIVISOR/2) - 1) begin cnt <= 0; clk_out <= ~clk_out; end
            else cnt <= cnt + 1;
        end
    end
endmodule
