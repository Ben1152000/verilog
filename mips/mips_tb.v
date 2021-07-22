

module Test_MIPS ();

    /* Make a regular pulsing clock */
    reg clk = 1;
    reg rst_n = 1'b0;
    always #1 clk = !clk;

    reg write = 0;
    reg [31:0] addr = 0;
    reg [31:0] wdata = 0;
    wire [31:0] rdata;

    mem m1 (
        .clk (clk)
    ,   .rst_n (rst_n)
    ,   .write (write)
    ,   .addr (addr)
    ,   .wdata (wdata)
    ,   .rdata (rdata)
    );

    initial begin
        $dumpfile("mips.vcd");
        $dumpvars(0, Test_MIPS);

        #8;
        rst_n = 1'b1;
        
        #4;
        write <= 1;
        addr <= 32'h1;
        wdata <= 32'hcafebabe;
        #4;
        addr <= 32'h2;
        wdata <= 32'hdeadbeef;
        #4;
        addr <= 32'h3;
        wdata <= 32'hc001bead;
        
        #4;
        write <= 0;
        addr <= 32'h0;
        #4;
        addr <= 32'h1;
        #4;
        addr <= 32'h2;
        #4;
        addr <= 32'h3;
        #4;
        addr <= 32'h4;

    end

    initial #256 $finish;


endmodule