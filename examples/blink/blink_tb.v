`timescale 1 ns/1 ps

module blink_tb;

    reg clk = 0;
    wire led_r, led_g, led_b;

    blink dut (
        .clk  (clk),
        .led_r(led_r),
        .led_g(led_g),
        .led_b(led_b)
    );

    initial begin
        $dumpfile("blink_tb.vcd");
        $dumpvars(0, blink_tb);

        $display("\nStarting simulation...\n");
        $display("  Time | R G B");
        $display("-------+------");

        // Use the monitor task to automaticaly display any change
        $monitor("%6d | %b %b %b", $time, led_r, led_g, led_b);

        forever #5 clk = !clk;
    end

    initial begin
        #1000000;

        $display("\nSimulation finished\n");
        $finish;
    end

endmodule
