

module Test_AHB_Lite ();

    /* Make a regular pulsing clock. */
    reg clock = 1;
    always #1 clock = !clock;

    wire write, trans, readyout;
    wire[7:0] waddr, wdata, rdata, value;

    Peripheral perry (clock, write, trans, waddr, wdata, readyout, rdata);
    Controller #(.VALUE(7)) conroy (clock, readyout, rdata, write, trans, waddr, wdata, value);

    initial begin
        $dumpfile("ahb_lite.vcd"); 
        $dumpvars(0, Test_AHB_Lite);

        #256 $finish;
    end

    always @(posedge clock) begin
        if (value == 1) $finish;
    end

endmodule