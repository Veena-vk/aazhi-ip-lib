/*
 * vga_controller.v — VGA Controller 640x480 @ 60 Hz
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Requires a 25.175 MHz pixel clock.
 * Timing (industry standard 640x480 @ 60 Hz):
 *   H: 640 active + 16 FP + 96 sync + 48 BP = 800 total
 *   V: 480 active + 10 FP +  2 sync + 33 BP = 525 total
 *
 * Ports:
 *   clk_25mhz     — 25.175 MHz pixel clock
 *   rst           — synchronous reset
 *   hsync, vsync  — sync outputs (active low)
 *   h_active, v_active — display-active region flags
 *   h_count[9:0]  — current horizontal pixel (0-799)
 *   v_count[9:0]  — current vertical  line  (0-524)
 *   display_on    — '1' inside visible area (use for pixel output)
 */
`timescale 1ns / 1ps
module vga_controller (
    input  wire       clk_25mhz,
    input  wire       rst,
    output reg        hsync,
    output reg        vsync,
    output wire       h_active,
    output wire       v_active,
    output wire       display_on,
    output reg  [9:0] h_count,
    output reg  [9:0] v_count
);
    // Horizontal timing
    localparam H_ACTIVE = 640;
    localparam H_FP     = 16;
    localparam H_SYNC   = 96;
    localparam H_BP     = 48;
    localparam H_TOTAL  = H_ACTIVE + H_FP + H_SYNC + H_BP; // 800

    // Vertical timing
    localparam V_ACTIVE = 480;
    localparam V_FP     = 10;
    localparam V_SYNC   = 2;
    localparam V_BP     = 33;
    localparam V_TOTAL  = V_ACTIVE + V_FP + V_SYNC + V_BP; // 525

    assign h_active    = (h_count < H_ACTIVE);
    assign v_active    = (v_count < V_ACTIVE);
    assign display_on  = h_active & v_active;

    always @(posedge clk_25mhz) begin
        if (rst) begin
            h_count <= 0; v_count <= 0; hsync <= 1; vsync <= 1;
        end else begin
            // Horizontal counter
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1) v_count <= 0;
                else                         v_count <= v_count + 1;
            end else h_count <= h_count + 1;

            // Sync pulses (active low)
            hsync <= ~((h_count >= H_ACTIVE + H_FP) &&
                       (h_count <  H_ACTIVE + H_FP + H_SYNC));
            vsync <= ~((v_count >= V_ACTIVE + V_FP) &&
                       (v_count <  V_ACTIVE + V_FP + V_SYNC));
        end
    end
endmodule
