

module Test_AHB_Lite ();

    /* Make a regular pulsing clock. */
    reg clock = 1;
    reg rst_n = 1'b0;
    always #1 clock = ~clock;

    wire write, trans, readyout;
    wire[7:0] waddr, wdata, rdata, value;

    Peripheral perry (
        .clock      (clock)
    ,   .rst_n      (rst_n)
    ,   .write      (write)
    ,   .trans      (trans)
    ,   .waddr      (waddr)
    ,   .wdata      (wdata)
    ,   .readyout   (readyout)
    ,   .rdata      (rdata)
    );
    Controller #(.VALUE(7)) conroy (
        .clock      (clock)
    ,   .rst_n      (rst_n)
    ,   .readyout   (readyout)
    ,   .rdata      (rdata)
    ,   .write      (write)
    ,   .trans      (trans)
    ,   .waddr      (waddr)
    ,   .wdata      (wdata)
    ,   .value      (value)
    );

    initial begin
        $dumpfile("ahb_lite.vcd"); 
        $dumpvars(0, Test_AHB_Lite);

        #10;
        rst_n = 1'b1;

        #256 $finish;
    end

    always @(posedge clock) begin
        if (value === 8'b1) $finish;
    end

endmodule
