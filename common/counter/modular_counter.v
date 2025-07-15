module modular_counter #(
    parameter COUNT_WIDTH   = 8,      // Bit-width of the counter
    parameter WRAP_AROUND   = 1'b0,   // 1: Wrap to START_VAL, 0: Hold at terminal count
    parameter START_VAL     = 0,      // Initial value on reset
    parameter STEP_SIZE     = 1,      // Increment/Decrement step size
    parameter DONE_PULSE    = 1'b1    // 1: done is 1-cycle pulse, 0: level until reset
)(
    input  wire                        count_clk,
    input  wire                        reset_n,
    input  wire                        count_enable,
    input  wire                        count_direction,        // 0: up, 1: down
    input  wire [COUNT_WIDTH-1:0]      count_limit,
    output reg  [COUNT_WIDTH-1:0]      count_val,
    output reg                         done
);

    wire [COUNT_WIDTH-1:0] next_up_val   = count_val + STEP_SIZE;
    wire [COUNT_WIDTH-1:0] next_down_val = count_val - STEP_SIZE;

    wire up_limit   = (next_up_val >= count_limit);
    wire down_limit = (next_down_val <= START_VAL);

    always @(posedge count_clk or negedge reset_n) begin
        if (!reset_n) begin
            count_val <= START_VAL;
            done      <= 1'b0;
        end else if (count_enable) begin
            // Clear done by default if pulse mode
            if (DONE_PULSE)
                done <= 1'b0;

            // Count direction control
            if (!count_direction) begin  // Count up
                if (!up_limit) begin
                    count_val <= next_up_val;
                    if (up_limit && DONE_PULSE == 1'b0)
                        done <= 1'b1;
                end else begin
                    if (WRAP_AROUND)
                        count_val <= START_VAL;
                    else
                        count_val <= count_val;
                    done <= 1'b1;
                end

            end else begin  // Count down
                if (!down_limit) begin
                    count_val <= next_down_val;
                    if (down_limit && DONE_PULSE == 1'b0)
                        done <= 1'b1;
                end else begin
                    if (WRAP_AROUND)
                        count_val <= count_limit;
                    else
                        count_val <= count_val;
                    done <= 1'b1;
                end
            end
        end
    end

endmodule
