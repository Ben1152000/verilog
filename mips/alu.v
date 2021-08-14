module alu (
    input wire [2:0]  op
,   input wire signed [31:0] in1
,   input wire signed [31:0] in2
,   output reg signed [31:0] out
,   output reg        zero
);

    always @* begin
        case (op)
            3'b000: out = in1 & in2;  /* and */
            3'b001: out = in1 | in2;  /* or  */
            3'b010: out = in1 + in2;  /* add */
            3'b011: out = 32'h0;
            3'b100: out = in2 << in1; /* sll */
            3'b101: out = in2 >> in1; /* srl */
            3'b110: out = in1 - in2;  /* sub */
            3'b111: out = in1 < in2;  /* slt */
        endcase
        zero = (out == 0);
    end

endmodule
