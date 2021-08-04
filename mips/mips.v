/* read only memory unit for instruction memory */
module rom (
    input wire [31:0] addr
,   output reg [31:0] rdata
);
    always @* begin
        case (addr)
            32'h00000000:   rdata = 32'h00000000;  // sll $zero $zero 0x0
            32'h00000004:   rdata = 32'h20080006;  // addi $t0 $zero 0x6
            32'h00000008:   rdata = 32'h2009000D;  // addi $t1 $zero 0xd
            32'h0000000c:   rdata = 32'h01095020;  // add $t2 $t0 $t1
            32'h00000010:   rdata = 32'h010A4020;  // add $t0 $t0 $t2
            32'h00000014:   rdata = 32'h00000000;
            32'h00000018:   rdata = 32'h00000000;
            32'h0000001c:   rdata = 32'h00000000;
            32'h00000020:   rdata = 32'h00000000;
            32'h00000024:   rdata = 32'h00000000;
            32'h00000028:   rdata = 32'h00000000;
            32'h0000002c:   rdata = 32'h00000000;
            32'h00000030:   rdata = 32'h00000000;
            32'h00000034:   rdata = 32'h00000000;
            32'h00000038:   rdata = 32'h00000000;
            32'h0000003c:   rdata = 32'h00000000;
            default: rdata = 32'h0;
        endcase
    end
endmodule



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



module regs (
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



module alu (
    input wire [2:0] op
,   input wire [31:0] in1
,   input wire [31:0] in2
,   output reg [31:0] out  /* don't forget to add flags */
);
    always @* begin
        case (op)
            3'b000: out = in1 & in2;  /* and */
            3'b001: out = in1 | in2;  /* or  */
            3'b010: out = in1 + in2;  /* add */
            3'b011: out = 32'h0;
            3'b100: out = 32'h0;
            3'b101: out = 32'h0;
            3'b110: out = in1 - in2;  /* sub */
            3'b111: out = in1 < in2;  /* slt */
        endcase
    end
endmodule



module control (
    input wire [5:0] opcode
,   input wire [5:0] funct
,   output reg [2:0] alu_op
,   output reg       alu_src
,   output reg       reg_dst
,   output reg       reg_write
);

    always @* begin
        alu_op = 3'b000;
        alu_src = 1'b0;
        reg_dst = 1'b0;
        reg_write = 1'b0;

        case (opcode)
            6'h0: begin
                case (funct)
                    6'h20: begin  /* add */
                        alu_op = 3'b010;
                        reg_dst = 1'b1;
                        reg_write = 1'b1;
                    end
                    6'h24: begin  /* and */
                        alu_op = 3'b000;
                        reg_dst = 1'b1;
                        reg_write = 1'b1;
                    end
                endcase
            end

            6'h8: begin  /* addi */
                alu_op = 3'b010;
                alu_src = 1'b1;
                reg_write = 1'b1;
            end

        endcase
        
    end

endmodule



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

    regs reg_file (
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