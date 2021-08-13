/* read/write memory unit */
module mem #(parameter MEMSIZE=1024) (
    input wire        clk
,   input wire        rst_n  /* reset active low */
,   input wire [31:0] raddr
,   output reg [31:0] rdata
,   input wire        write
,   input wire [31:0] waddr
,   input wire [31:0] wdata
);

    reg [7:0] mem [MEMSIZE - 1:0];
    reg        write_next;
    reg [31:0] waddr_next;
    reg [31:0] wdata_next;
    
    integer i;

    always @(posedge clk) begin
        if (~rst_n) begin
            for (i = 0; i < MEMSIZE; i = i + 1) 
                mem[i] <= 8'h0;
        end else begin
            if (write_next) begin
                mem[waddr_next]     <= wdata_next[31:24];
                mem[waddr_next + 1] <= wdata_next[23:16];
                mem[waddr_next + 2] <= wdata_next[15:8];
                mem[waddr_next + 3] <= wdata_next[7:0];
            end
        end
    end

    always @* begin
        write_next = write;
        waddr_next = waddr;
        wdata_next = wdata;

        rdata[31:24] = mem[raddr];
        rdata[23:16] = mem[raddr + 1];
        rdata[15:8]  = mem[raddr + 2];
        rdata[7:0]   = mem[raddr + 3];
    end

endmodule
