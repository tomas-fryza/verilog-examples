module counter_top (
    input  wire        clk,   // Main clock
    input  wire        btnu,  // Synchronous reset
    output wire [15:0] led,   // 16-bit counter value
    output wire [6:0]  seg,   // Seven-segment cathodes CA..CG (active-low)
    output wire        dp,    // Decimal point
    output wire [7:0]  an     // Seven-segment anodes AN7..AN0 (active-low)
);

    // Internal signals
    wire       en_250ms;  // Clock enable for 4-bit counter
    wire [3:0] cnt_4bit;  // 4-bit counter value
    wire       en_2ms;    // Clock enable for 16-bit counter

    // ---------------------------------------------------------
    // Clock enable for 250 ms
    // ---------------------------------------------------------
    clk_en #(
        .MAX (25_000_000)
    ) u_enable0 (
        .i_clk (clk),
        .i_rst (btnu),
        .o_ce  (en_250ms)
    );

    // ---------------------------------------------------------
    // 4-bit binary counter
    // ---------------------------------------------------------
    counter #(
        .N (4)
    ) u_counter0 (
        .i_clk (clk),
        .i_rst (btnu),
        .i_en  (en_250ms),
        .o_cnt (cnt_4bit)
    );

    // ---------------------------------------------------------
    // Binary to 7-segment decoder
    // ---------------------------------------------------------
    bin2seg u_segment (
        .i_bin (cnt_4bit),
        .o_seg (seg)
    );

    // Turn off decimal point (active-low → 1 = off)
    assign dp = 1'b1;

    // Enable only rightmost digit (active-low)
    assign an = 8'b1111_1110;

    // ---------------------------------------------------------
    // Clock enable for 2 ms
    // ---------------------------------------------------------
    clk_en #(
        .MAX (200_000)
    ) u_enable1 (
        .i_clk (clk),
        .i_rst (btnu),
        .o_ce  (en_2ms)
    );

    // ---------------------------------------------------------
    // 16-bit binary counter
    // ---------------------------------------------------------
    counter #(
        .N (16)
    ) u_counter1 (
        .i_clk (clk),
        .i_rst (btnu),
        .i_en  (en_2ms),
        .o_cnt (led)
    );

endmodule
