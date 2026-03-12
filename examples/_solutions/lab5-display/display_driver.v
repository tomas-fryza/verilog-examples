module display_driver (
    input  wire       i_clk,   //! Main clock
    input  wire       i_rst,   //! High-active synchronous reset
    input  wire [7:0] i_data,  //! Two hexadecimal digits
    output wire [6:0] o_seg,   //! {a,b,c,d,e,f,g} active-low
    output wire [1:0] o_anode  //! Seven-segment anodes AN1..AN0 (active-low)
);

    // Internal signals
    wire       w_en;
    wire       w_digit;
    wire [3:0] w_bin;

    // ---------------------------------------------------------
    // Clock enable generator for refresh timing
    // ---------------------------------------------------------
    clk_en #(
        .MAX (32)  // Adjust for flicker-free multiplexing
                   // For simulation: 32
    ) clock_0 (    // For implementation: 3_200_000
        .i_clk (i_clk),
        .i_rst (i_rst),
        .o_ce  (w_en)
    );

    // ---------------------------------------------------------
    // N-bit counter for digit selection
    // ---------------------------------------------------------
    counter #(
        .N (1)
    ) counter_0 (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .i_en  (w_en),
        .o_cnt (w_digit)
    );

    // ---------------------------------------------------------
    // Digit select multiplexer
    // ---------------------------------------------------------
    // w_digit = 0 -> right digit  (i_data[3:0])
    // w_digit = 1 -> left digit   (i_data[7:4])
    assign w_bin = (w_digit == 1'b0) ? i_data[3:0] : i_data[7:4];

    // ---------------------------------------------------------
    // 7-segment decoder
    // ---------------------------------------------------------
    bin2seg decoder_0 (
        .i_bin (w_bin),
        .o_seg (o_seg)
    );

    // ---------------------------------------------------------
    // Anode select (active-low)
    // ---------------------------------------------------------
    assign o_anode = (w_digit) ? 2'b01 : 2'b10;

endmodule