/*
 * async_fifo.v — Asynchronous FIFO (dual clock domain)
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Uses Gray-code pointers and 2-FF synchronizers for safe CDC.
 *
 * Parameters:
 *   DATA_WIDTH — word width (default 8)
 *   DEPTH      — FIFO depth, power of 2 (default 16)
 *
 * Ports:
 *   wr_clk, wr_rst — write clock / reset
 *   wr_en, din     — write enable / data
 *   full           — write-domain full flag
 *   rd_clk, rd_rst — read clock / reset
 *   rd_en, dout    — read enable / data
 *   empty          — read-domain empty flag
 */
`timescale 1ns / 1ps
module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16
)(
    input  wire                  wr_clk,
    input  wire                  wr_rst,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] din,
    output wire                  full,
    input  wire                  rd_clk,
    input  wire                  rd_rst,
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] dout,
    output wire                  empty
);
    localparam ADDR_W = $clog2(DEPTH);
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Write domain
    reg [ADDR_W:0] wr_ptr_bin = 0, wr_ptr_gray = 0;
    // Read domain
    reg [ADDR_W:0] rd_ptr_bin = 0, rd_ptr_gray = 0;

    // Synchronizers
    reg [ADDR_W:0] wr_gray_s1 = 0, wr_gray_s2 = 0;
    reg [ADDR_W:0] rd_gray_s1 = 0, rd_gray_s2 = 0;

    function [ADDR_W:0] bin2gray; input [ADDR_W:0] b; bin2gray = b ^ (b >> 1); endfunction
    function [ADDR_W:0] gray2bin;
        input [ADDR_W:0] g; integer i;
        begin gray2bin = g;
            for (i = ADDR_W-1; i >= 0; i = i-1) gray2bin[i] = gray2bin[i+1] ^ g[i];
        end
    endfunction

    assign dout  = mem[rd_ptr_bin[ADDR_W-1:0]];
    assign full  = (wr_ptr_gray == {~rd_gray_s2[ADDR_W:ADDR_W-1], rd_gray_s2[ADDR_W-2:0]});
    assign empty = (rd_ptr_gray == wr_gray_s2);

    // Write logic
    always @(posedge wr_clk) begin
        if (wr_rst) begin wr_ptr_bin <= 0; wr_ptr_gray <= 0; end
        else if (wr_en && !full) begin
            mem[wr_ptr_bin[ADDR_W-1:0]] <= din;
            wr_ptr_bin  <= wr_ptr_bin + 1;
            wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
        end
    end
    // Read logic
    always @(posedge rd_clk) begin
        if (rd_rst) begin rd_ptr_bin <= 0; rd_ptr_gray <= 0; end
        else if (rd_en && !empty) begin
            rd_ptr_bin  <= rd_ptr_bin + 1;
            rd_ptr_gray <= bin2gray(rd_ptr_bin + 1);
        end
    end
    // Synchronize wr_ptr to rd_clk
    always @(posedge rd_clk) begin rd_gray_s1 <= wr_ptr_gray; rd_gray_s2 <= rd_gray_s1; end
    // Synchronize rd_ptr to wr_clk
    always @(posedge wr_clk) begin wr_gray_s1 <= rd_ptr_gray; wr_gray_s2 <= wr_gray_s1; end
endmodule
