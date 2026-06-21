/*
 * sync_fifo.v — Synchronous FIFO (single clock domain)
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Parameters:
 *   DATA_WIDTH — word width  (default 8)
 *   DEPTH      — FIFO depth  (must be power of 2, default 16)
 *
 * Ports:
 *   clk, rst   — clock / synchronous reset
 *   wr_en      — write enable
 *   din        — write data
 *   full       — FIFO full
 *   rd_en      — read enable
 *   dout       — read data
 *   empty      — FIFO empty
 *   count      — number of entries in FIFO
 */
`timescale 1ns / 1ps
module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16
)(
    input  wire                       clk,
    input  wire                       rst,
    input  wire                       wr_en,
    input  wire [DATA_WIDTH-1:0]      din,
    output wire                       full,
    input  wire                       rd_en,
    output wire [DATA_WIDTH-1:0]      dout,
    output wire                       empty,
    output wire [$clog2(DEPTH):0]     count
);
    localparam ADDR_W = $clog2(DEPTH);
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_W:0] wr_ptr = 0;
    reg [ADDR_W:0] rd_ptr = 0;

    assign full  = (wr_ptr[ADDR_W] != rd_ptr[ADDR_W]) &&
                   (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
    assign empty = (wr_ptr == rd_ptr);
    assign count = wr_ptr - rd_ptr;
    assign dout  = mem[rd_ptr[ADDR_W-1:0]];

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0; rd_ptr <= 0;
        end else begin
            if (wr_en && !full)  begin mem[wr_ptr[ADDR_W-1:0]] <= din; wr_ptr <= wr_ptr + 1; end
            if (rd_en && !empty) rd_ptr <= rd_ptr + 1;
        end
    end
endmodule
