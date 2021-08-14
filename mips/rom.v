/* read only memory unit for instruction memory */
module rom (
    input wire [31:0] addr
,   output reg [31:0] rdata
);

    always @* begin
        case (addr)
            32'h00000000:   rdata = 32'h2008001B;  //    addi    $t0,    $zero,  0x1b
            32'h00000004:   rdata = 32'h00004820;  //    add     $t1,    $zero,  $zero
            32'h00000008:   rdata = 32'h00095080;  //    sll     $t2,    $t1,    0x2
            32'h0000000c:   rdata = 32'hAD480000;  //    sw      $t0,    0x0($t2)
            32'h00000010:   rdata = 32'h00085042;  //    srl     $t2,    $t0,    0x1
            32'h00000014:   rdata = 32'h000A5840;  //    sll     $t3,    $t2,    0x1
            32'h00000018:   rdata = 32'h110B0003;  //    beq     $t0,    $t3,    0x3
            32'h0000001c:   rdata = 32'h00085040;  //    sll     $t2,    $t0,    0x1
            32'h00000020:   rdata = 32'h01485020;  //    add     $t2,    $t2,    $t0
            32'h00000024:   rdata = 32'h214A0001;  //    addi    $t2,    $t2,    0x1
            32'h00000028:   rdata = 32'h01404020;  //    add     $t0,    $t2,    $zero
            32'h0000002c:   rdata = 32'h21290001;  //    addi    $t1,    $t1,    0x1
            32'h00000030:   rdata = 32'h200A0002;  //    addi    $t2,    $zero,  0x2
            32'h00000034:   rdata = 32'h010A502A;  //    slt     $t2,    $t0,    $t2
            32'h00000038:   rdata = 32'h1140FFF3;  //    beq     $t2,    $zero, -0x13
            default: rdata = 32'h0;
        endcase
    end

endmodule

// Collatz Conjecture:
// 0x2008001B      addi    $t0,    $zero,  0x1b
// 0x00004820      add     $t1,    $zero,  $zero
// 0x00095080      sll     $t2,    $t1,    0x2
// 0xAD480000      sw      $t0,    0x0($t2)
// 0x00085042      srl     $t2,    $t0,    0x1
// 0x000A5840      sll     $t3,    $t2,    0x1
// 0x110B0003      beq     $t0,    $t3,    0x3
// 0x00085040      sll     $t2,    $t0,    0x1
// 0x01485020      add     $t2,    $t2,    $t0
// 0x214A0001      addi    $t2,    $t2,    0x1
// 0x01404020      add     $t0,    $t2,    $zero
// 0x21290001      addi    $t1,    $t1,    0x1
// 0x200A0002      addi    $t2,    $zero,  0x2
// 0x010A502A      slt     $t2,    $t0,    $t2
// 0x1140FFF3      beq     $t2,    $zero, -0x13