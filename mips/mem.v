/* read/write memory unit */
module mem #(parameter MEMSIZE=1024) (
    input wire        clk
,   input wire        rst_n  /* reset active low */
,   input wire        write  /* low is read, high is write */
,   input wire [31:0] addr
,   input wire [31:0] wdata
,   output reg [31:0] rdata
);

    reg [31:0] rdata_next;
    reg [7:0] mem [MEMSIZE - 1:0];

    integer i;

    always @(posedge clk) begin
        if (~rst_n) begin
            rdata <= 32'h0;
            for (i = 0; i < MEMSIZE; i = i + 1) 
                mem[i] <= 8'h0;
        end else begin
            rdata <= rdata_next;
        end
    end

    always @* begin
        rdata_next = rdata;
        if (write) begin
            mem[addr]     = wdata[31:24];
            mem[addr + 1] = wdata[23:16];
            mem[addr + 2] = wdata[15:8];
            mem[addr + 3] = wdata[7:0];
        end else begin
            rdata_next[31:24] = mem[addr];
            rdata_next[23:16] = mem[addr + 1];
            rdata_next[15:8]  = mem[addr + 2];
            rdata_next[7:0]   = mem[addr + 3];
        end
    end

endmodule
