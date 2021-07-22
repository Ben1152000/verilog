
/* read/write memory unit */
module mem (
    input wire        clk
,   input wire        rst_n  /* reset active low */
,   input wire        write  /* low is read, high is write */
,   input wire [31:0] addr
,   input wire [31:0] wdata
,   output reg [31:0] rdata
);
    reg [31:0] rdata_next;
    reg [31:0] mem [31:0];

    integer i;

    always @(posedge clk) begin
        if (~rst_n) begin
            rdata <= 32'h0;
            for (i = 0; i < 32; i = i + 1) 
                mem[i] <= 32'h0;
        end else begin
            rdata <= rdata_next;
        end
    end

    always @* begin
        if (write) mem[addr] <= wdata;  /* write */
        else rdata_next <= mem[addr];  /* read */
    end

endmodule

// module mips (
//     input                   clk,
//     input                   rstn,  /* reset active low */

// );
//     reg [31:0] pc;  /* program counter */

//     mem inst_mem (
//         .clk (clk),
//         .rstn (rstn),
//         .write (write),
//         .addr (addr),
//         .wdata (wdata),
//         .rdata (rdata)
//     );

// endmodule