module sync_fifo #(
    parameter FIFO_DEPTH = 1024,
    parameter FIFO_WIDTH = 32
)(
    input  wire                        fifo_clk,
    input  wire                        fifo_sync_rst_n,
    input  wire                        fifo_write,
    input  wire                        fifo_read,
    input  wire [FIFO_WIDTH-1:0]       fifo_input,
    input  wire [$clog2(FIFO_DEPTH):0] prog_full_thresh,
    input  wire [$clog2(FIFO_DEPTH):0] prog_empty_thresh,
    output reg  [FIFO_WIDTH-1:0]       fifo_output,
    output wire                        fifo_full,
    output wire                        fifo_empty,
    output wire                        prog_full,
    output wire                        prog_empty
);


    localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

    // FIFO memory array
    reg [FIFO_WIDTH-1:0] fifo_reg [0:FIFO_DEPTH-1];

    // Read and write pointers (one bit wider for wraparound detection)
    reg [PTR_WIDTH:0] read_pointer;
    reg [PTR_WIDTH:0] write_pointer;

    // FIFO count logic
    wire [PTR_WIDTH:0] fifo_count;
    assign fifo_count = write_pointer - read_pointer;

    // Status flags
    assign fifo_full  = (fifo_count == FIFO_DEPTH);
    assign fifo_empty = (fifo_count == 0);
    assign prog_full  = (fifo_count >= prog_full_thresh);
    assign prog_empty = (fifo_count <= prog_empty_thresh);

    always @(posedge fifo_clk) begin
        if (!fifo_sync_rst_n) begin
            read_pointer  <= 0;
            write_pointer <= 0;
            fifo_output   <= 0;
        end else begin
            // Write operation
            if (fifo_write && !fifo_full) begin
                fifo_reg[write_pointer[module sync_fifo #(
    parameter FIFO_DEPTH = 1024,
    parameter FIFO_WIDTH = 32
)(
    input  wire                        fifo_clk,
    input  wire                        fifo_sync_rst_n,
    input  wire                        fifo_write,
    input  wire                        fifo_read,
    input  wire [FIFO_WIDTH-1:0]       fifo_input,
    input  wire [$clog2(FIFO_DEPTH):0] prog_full_thresh,
    input  wire [$clog2(FIFO_DEPTH):0] prog_empty_thresh,
    output reg  [FIFO_WIDTH-1:0]       fifo_output,
    output wire                        fifo_full,
    output wire                        fifo_empty,
    output wire                        prog_full,
    output wire                        prog_empty
);


    localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

    // FIFO memory array
    reg [FIFO_WIDTH-1:0] fifo_reg [0:FIFO_DEPTH-1];

    // Read and write pointers (one bit wider for wraparound detection)
    reg [PTR_WIDTH:0] read_pointer;
    reg [PTR_WIDTH:0] write_pointer;

    // FIFO count logic
    wire [PTR_WIDTH:0] fifo_count;
    assign fifo_count = write_pointer - read_pointer;

    // Status flags
    assign fifo_full  = (fifo_count == FIFO_DEPTH);
    assign fifo_empty = (fifo_count == 0);
    assign prog_full  = (fifo_count >= prog_full_thresh);
    assign prog_empty = (fifo_count <= prog_empty_thresh);

    always @(posedge fifo_clk) begin
        if (!fifo_sync_rst_n) begin
            read_pointer  <= 0;
            write_pointer <= 0;
            fifo_output   <= 0;
        end else begin
            // Write operation
            if (fifo_write && !fifo_full) begin
                fifo_reg[write_pointer[PTR_WIDTH-1:0]] <= fifo_input;
                write_pointer <= write_pointer + 1;
            end

            // Read operation
            if (fifo_read && !fifo_empty) begin
                fifo_output <= fifo_reg[read_pointer[PTR_WIDTH-1:0]];
                read_pointer <= read_pointer + 1;
            end
        end
    end

endmodule
-1:0]] <= fifo_input;
                write_pointer <= write_pointer + 1;
            end

            // Read operation
            if (fifo_read && !fifo_empty) begin
                fifo_output <= fifo_reg[read_pointer[PTR_WIDTH-1:0]];
                read_pointer <= read_pointer + 1;
            end
        end
    end

endmodule
