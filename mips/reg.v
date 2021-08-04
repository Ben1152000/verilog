module reg_file (
    input wire        clk
,   input wire        rst_n
,   input wire        write
,   input wire [4:0]  sreg
,   input wire [4:0]  treg
,   input wire [4:0]  wreg
,   input wire [31:0] wdata
,   output reg [31:0] sdata
,   output reg [31:0] tdata
);

    reg [4:0] wreg_next;
    reg [31:0] wdata_next;
    reg [31:0] mem [31:0];

    integer i;

    always @(posedge clk) begin
        if (~rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                mem[i] <= 32'h0;
        end else begin
            if (wreg_next !== 0)  /* do nothing if zero reg */
                mem[wreg_next] <= wdata_next;
        end
    end

    always @* begin
        sdata = mem[sreg];
        tdata = mem[treg];
        if (write) begin
            wreg_next = wreg;
            wdata_next = wdata;
        end else begin
            wreg_next = 5'h0;
            wdata_next = 32'h0;
        end
    end

endmodule
