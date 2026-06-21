/*
 * pwm.v — Pulse Width Modulator
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Parameters:
 *   WIDTH — counter/duty-cycle width in bits (default 8 → 256 steps)
 *
 * Ports:
 *   clk        — system clock
 *   rst        — synchronous reset
 *   duty[WIDTH-1:0] — duty cycle (0=0%, 2^WIDTH-1 = ~100%)
 *   pwm_out    — PWM output
 */
`timescale 1ns / 1ps
module pwm #(parameter WIDTH = 8)(
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] duty,
    output wire             pwm_out
);
    reg [WIDTH-1:0] counter = 0;
    always @(posedge clk) begin
        if (rst) counter <= 0;
        else     counter <= counter + 1;
    end
    assign pwm_out = (counter < duty);
endmodule
