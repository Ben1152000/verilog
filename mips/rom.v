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
