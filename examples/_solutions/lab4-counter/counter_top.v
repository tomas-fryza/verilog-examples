module counter_top (
    input  wire        clk,        // Main clock
    input  wire        btnu,       // Synchronous reset
    output wire [15:0] led,        // 16-bit counter value
    output wire [6:0]  seg,        // Seven-segment cathodes CA..CG (active-low)
    output wire        dp,         // Decimal point
    output wire [7:0]  an          // Seven-segment anodes AN7..AN0 (active-low)
);

    // Internal signals
    wire        sig_en_250ms;   // Clock enable for 4-bit counter
    wire [3:0]  sig_cnt_4bit;   // 4-bit counter value
    wire        sig_en_2ms;     // Clock enable for 16-bit counter

    // ---------------------------------------------------------
    // Clock enable for 250 ms
    // ---------------------------------------------------------
    clk_en #(
        .MAX(25_000_000)
    ) clk_en0 (
        .clk(clk),
        .rst(btnu),
        .ce(sig_en_250ms)
    );

    // ---------------------------------------------------------
    // 4-bit binary counter
    // ---------------------------------------------------------
    counter #(
        .BITS(4)
    ) counter0 (
        .clk(clk),
        .rst(btnu),
        .en(sig_en_250ms),
        .cnt(sig_cnt_4bit)
    );

    // ---------------------------------------------------------
    // Binary to 7-segment decoder
    // ---------------------------------------------------------
    bin2seg display (
        .bin(sig_cnt_4bit),
        .seg(seg)
    );

    // Turn off decimal point (active-low → 1 = off)
    assign dp = 1'b1;

    // Enable only rightmost digit (active-low)
    assign an = 8'b1111_1110;

    // ---------------------------------------------------------
    // Clock enable for 2 ms
    // ---------------------------------------------------------
    clk_en #(
        .MAX(200_000)
    ) clk_en1 (
        .clk(clk),
        .rst(btnu),
        .ce(sig_en_2ms)
    );

    // ---------------------------------------------------------
    // 16-bit binary counter
    // ---------------------------------------------------------
    counter #(
        .BITS(16)
    ) counter1 (
        .clk(clk),
        .rst(btnu),
        .en(sig_en_2ms),
        .cnt(led)
    );

endmodule
