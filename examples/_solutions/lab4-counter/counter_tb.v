`timescale 1ns/1ps

module counter_tb ();

    // Local parameter value is fixed inside the module
    localparam N = 5;  // Change only this value to scale the counter

    // Testbench signals
    reg          clk;
    reg          rst;
    reg          en;
    wire [N-1:0] cnt;

    // Instantiate the counter
    counter #(
        .N (N)
    ) dut (
        .i_clk (clk),
        .i_rst (rst),
        .i_en  (en),
        .o_cnt (cnt)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // The initial block executes once at the start of the simulation
    initial begin
        // Waveform dump for GTKWave
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);

        // Initialize
        clk = 0;
        rst = 0;
        en  = 1;

        // Reset generation
        rst = 1;
        #50;         // 50 ns
        rst = 0;
        #100;        // 100 ns
    
        // Clock enable sequence
        #330;        // 33 periods
        en = 0;
        #60;         // 6 periods
        en = 1;
        #10;         // 1 period
        en = 0;
        #60;         // 6 periods
        en = 1;
        #10;         // 1 period
        en = 0;
        #60;         // 6 periods
        en = 1;
        #10;         // 1 period
        en = 0;
        #60;         // 6 periods
 
        // Finish simulation
        $display("\nSimulation finished\n");
        $finish;
    end

    // Monitor outputs
    initial begin
        $display(" Time \tclk \trst \ten \tcnt");
        $monitor("[%4d] \t%b \t%b \t%b \t%0d",
            $time, clk, rst, en, cnt);
    end

endmodule
