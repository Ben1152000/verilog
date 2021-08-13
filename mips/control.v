module control (
    input wire [5:0] opcode
,   input wire [5:0] funct
,   output reg [2:0] alu_op
,   output reg       alu_src
,   output reg       alu_shift
,   output reg       branch
,   output reg       mem_to_reg
,   output reg       mem_write
,   output reg       reg_dst
,   output reg       reg_write
);

    always @* begin
        alu_op = 3'b000;
        alu_src = 1'b0;
        alu_shift = 1'b0;
        branch = 1'b0;
        mem_to_reg = 1'b0;
        mem_write = 1'b0;
        reg_dst = 1'b0;
        reg_write = 1'b0;

        case (opcode)
            6'h0: begin
                case (funct)
                    6'h0: begin  /* sll */
                        alu_op = 3'b100;
                        alu_shift = 1'b1;
                        reg_dst = 1'b1;
                        reg_write = 1'b1;
                    end

                    6'h20: begin  /* add */
                        alu_op = 3'b010;
                        reg_dst = 1'b1;
                        reg_write = 1'b1;
                    end

                    6'h22: begin /* sub */
                        alu_op = 3'b110;
                        reg_dst = 1'b1;
                        reg_write = 1'b1;
                    end

                    6'h24: begin  /* and */
                        alu_op = 3'b000;
                        reg_dst = 1'b1;
                        reg_write = 1'b1;
                    end

                    6'h25: begin  /* or */
                        alu_op = 3'b001;
                        reg_dst = 1'b1;
                        reg_write = 1'b1;
                    end
                    
                    // 6'h2a:  /* slt */

                endcase
            end

            // 6'h2:  /* j */

            6'h4: begin  /* beq */
                alu_op = 3'b110;
                branch = 1'b1;
            end

            6'h8: begin  /* addi */
                alu_op = 3'b010;
                alu_src = 1'b1;
                reg_write = 1'b1;
            end

            6'h23: begin  /* lw */
                alu_op = 3'b010;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
            end

            6'h2b: begin  /* sw */
                alu_op = 3'b010;
                alu_src = 1'b1;
                mem_write = 1'b1;
            end

        endcase
        
    end

endmodule
