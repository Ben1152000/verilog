module mips (
    input wire clk
,   input wire rst_n
);

    reg  [31:0] pc;  /* program counter */
    reg  [31:0] pc_next;
    wire [31:0] inst;
    reg  [31:0] immed;
    
    reg  [4:0]  wreg;
    reg  [31:0] wdata;
    wire [31:0] sdata;
    wire [31:0] tdata;

    wire [2:0]  op;
    reg  [31:0] alu_in1;
    reg  [31:0] alu_in2;
    wire [31:0] alu_out;
    wire        zero;

    wire [31:0] rdata;

    wire alu_src;
    wire alu_shift;
    wire branch;
    wire mem_to_reg;
    wire mem_read;
    wire mem_write;
    wire reg_dst;
    wire reg_write;

    rom inst_mem (
        .addr  (pc)
    ,   .rdata (inst)
    );

    reg_file reg_file (
        .clk   (clk)
    ,   .rst_n (rst_n)
    ,   .write (reg_write)
    ,   .sreg  (inst[25:21])
    ,   .treg  (inst[20:16])
    ,   .wreg  (wreg)
    ,   .wdata (wdata)
    ,   .sdata (sdata)
    ,   .tdata (tdata)
    );

    alu alu (
        .op   (op)
    ,   .in1  (alu_in1)
    ,   .in2  (alu_in2)
    ,   .out  (alu_out)
    ,   .zero (zero)
    );

    control control (
        .opcode     (inst[31:26])
    ,   .funct      (inst[5:0])
    ,   .alu_op     (op)
    ,   .alu_src    (alu_src)
    ,   .alu_shift  (alu_shift)
    ,   .branch     (branch)
    ,   .mem_to_reg (mem_to_reg)
    ,   .mem_read   (mem_read)
    ,   .mem_write  (mem_write)
    ,   .reg_dst    (reg_dst)
    ,   .reg_write  (reg_write)
    );
    
    mem mem (
        .clk   (clk)
    ,   .rst_n (rst_n)
    ,   .read  (mem_read)
    ,   .raddr (alu_out)
    ,   .rdata (rdata)
    ,   .write (mem_write)
    ,   .waddr (alu_out)
    ,   .wdata (tdata)
    );

    always @(posedge clk) begin
        if (~rst_n) begin
            pc <= 32'h0;
        end else begin
            pc <= pc_next;
        end
    end

    always @* begin
        pc_next = pc + 4 + ((branch & zero)? immed << 2 : 0);
        immed = {{16{inst[15]}}, inst[15:0]};  /* sign extended */
        wreg = reg_dst ? inst[15:11] : inst[20:16];
        wdata = mem_to_reg ? rdata : alu_out;
        alu_in1 = alu_shift ? inst[10:6] : sdata;
        alu_in2 = alu_src ? immed : tdata;  /* sign extend */
    end

endmodule
