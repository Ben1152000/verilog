module Test_MIPS ();

    /* Make a regular pulsing clock */
    reg clk = 1;
    reg rst_n = 1'b0;
    always #1 clk = !clk;

    mips core (
        .clk   (clk)
    ,   .rst_n (rst_n)
    );

    initial begin
        $dumpfile("mips.vcd");
        $dumpvars(0, Test_MIPS);

        #4; rst_n = 1'b1;
    end

    initial #64 $finish;

endmodule
