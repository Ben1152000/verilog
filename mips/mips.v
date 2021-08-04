module mips (
    input wire clk
,   input wire rst_n
);

    reg [31:0] pc;  /* program counter */
    reg [31:0] pc_next;
    wire [31:0] inst;
    wire write;
    wire [31:0] wdata;
    wire [31:0] sdata;
    wire [31:0] tdata;
    wire [2:0] op;
    wire alu_src;
    wire reg_dst;
    reg [4:0] wreg;
    reg [31:0] alu_in;

    rom inst_mem (
        .addr  (pc)
    ,   .rdata (inst)
    );

    reg_file reg_file (
        .clk   (clk)
    ,   .rst_n (rst_n)
    ,   .write (write)
    ,   .sreg  (inst[25:21])
    ,   .treg  (inst[20:16])
    ,   .wreg  (wreg)
    ,   .wdata (wdata)
    ,   .sdata (sdata)
    ,   .tdata (tdata)
    );

    alu alu (
        .op    (op)
    ,   .in1 (sdata)
    ,   .in2 (alu_in)
    ,   .out (wdata)
    );

    control control (
        .opcode    (inst[31:26])
    ,   .funct     (inst[5:0])
    ,   .alu_op    (op)
    ,   .alu_src   (alu_src)
    ,   .reg_dst   (reg_dst)
    ,   .reg_write (write)
    );

    always @(posedge clk) begin
        if (~rst_n) begin
            pc <= 32'h0;
        end else begin
            pc <= pc_next;
        end
    end

    always @* begin
        pc_next = pc + 4;
        wreg = reg_dst ? inst[15:11] : inst[20:16];
        alu_in = alu_src ? {{16{inst[15]}}, inst[15:0]} : tdata;  /* sign extend */
    end

endmodule