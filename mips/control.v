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
