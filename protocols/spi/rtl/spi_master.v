/*
 * spi_master.v — SPI Master Controller
 *
 * Author  : aazhi-ip-lib contributors
 * License : MIT
 * Source  : https://github.com/Veena-vk/aazhi-ip-lib
 *
 * Supports SPI modes 0-3 (CPOL/CPHA), configurable word width and clock divider.
 *
 * Parameters:
 *   DATA_WIDTH  — SPI word width (default 8)
 *   CLK_DIV     — sclk = clk / (2 * CLK_DIV)
 *   CPOL        — clock polarity (0 or 1)
 *   CPHA        — clock phase    (0 or 1)
 *
 * Ports:
 *   clk, rst         — system clock / reset
 *   din[DATA_WIDTH-1:0] — data to transmit
 *   din_valid        — pulse to start transfer
 *   dout[DATA_WIDTH-1:0]— received data (valid when done=1)
 *   done             — transfer complete (1-cycle pulse)
 *   busy             — transfer in progress
 *   sclk, mosi, miso — SPI bus
 *   cs_n             — chip select (active low)
 */
`timescale 1ns / 1ps
module spi_master #(
    parameter DATA_WIDTH = 8,
    parameter CLK_DIV    = 4,
    parameter CPOL       = 0,
    parameter CPHA       = 0
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire [DATA_WIDTH-1:0] din,
    input  wire                  din_valid,
    output reg  [DATA_WIDTH-1:0] dout,
    output reg                   done,
    output wire                  busy,
    output reg                   sclk,
    output reg                   mosi,
    input  wire                  miso,
    output reg                   cs_n
);
    localparam IDLE    = 2'd0;
    localparam SETUP   = 2'd1;
    localparam SHIFT   = 2'd2;
    localparam FINISH  = 2'd3;

    reg [1:0]              state = IDLE;
    reg [$clog2(CLK_DIV):0] clk_cnt = 0;
    reg [$clog2(DATA_WIDTH):0] bit_idx = 0;
    reg [DATA_WIDTH-1:0]   shift_reg = 0;
    reg                    sclk_en = 0;

    assign busy = (state != IDLE);

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE; cs_n <= 1; sclk <= CPOL;
            mosi <= 0; done <= 0; dout <= 0;
            clk_cnt <= 0; bit_idx <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: begin
                    sclk <= CPOL; cs_n <= 1;
                    if (din_valid) begin
                        shift_reg <= din;
                        bit_idx   <= DATA_WIDTH - 1;
                        clk_cnt   <= 0;
                        cs_n      <= 0;
                        state     <= SETUP;
                    end
                end
                SETUP: begin
                    if (clk_cnt < CLK_DIV-1) clk_cnt <= clk_cnt + 1;
                    else begin
                        clk_cnt <= 0;
                        mosi    <= shift_reg[bit_idx];
                        state   <= SHIFT;
                    end
                end
                SHIFT: begin
                    if (clk_cnt < CLK_DIV-1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        sclk <= ~sclk;
                        if (sclk == CPOL) begin // rising (sample on CPOL=0)
                            shift_reg[0] <= miso;
                            if (bit_idx == 0) state <= FINISH;
                            else begin
                                bit_idx <= bit_idx - 1;
                                mosi    <= shift_reg[bit_idx-1];
                            end
                        end
                    end
                end
                FINISH: begin
                    sclk  <= CPOL; cs_n <= 1;
                    dout  <= shift_reg; done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
