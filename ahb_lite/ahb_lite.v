
module Controller #(parameter VALUE=1) (
    input wire clock, readyout,
    input wire[7:0] rdata,
    output reg write, trans,
    output reg[7:0] waddr, wdata, value
);
    reg set, await;

    initial trans <= 0;
    initial value <= VALUE;  // Initial Collatz value
    initial set <= 0;
    initial await <= 0;

    always @(posedge clock) begin
        if (set == 0) begin
            write <= 1;
            trans <= 1;
            waddr <= 8'b0;
            if (await) begin
                value <= rdata;
                wdata <= rdata;
                await <= 0;
            end else begin
                wdata <= value;
            end
            set <= 1;
        end else if (set == 1 && await == 0) begin
            write <= 0;
            trans <= 1;
            waddr <= value;
            await <= 1;
        end else if (set == 1 && await == 1) begin
            trans <= 0;
            set <= 0;
        end
    end

endmodule

/*
 * This module has two modes: even and odd. When in even mode, a read
 * transaction returns the value of waddr * 2 in the rdata wire. When in odd
 * mode, a read transaction returns the value of waddr * 3 + 1. Swiching between
 * modes is accomplished by writing an even or odd number to address 1.
 */
module Peripheral (
    input wire clock, write, trans,
    input wire[7:0] waddr, wdata,
    output reg readyout,
    output reg[7:0] rdata
);
    reg mode;

    initial mode <= 1'b0;  // Begin in even mode.

    always @(posedge clock) begin
        if (trans == 0) begin
            readyout <= 0;
        end else if (trans == 1 && write == 1) begin
            if (waddr == 0)  // Update mode
                mode <= wdata[0];
            rdata <= wdata;
            readyout <= 1;
        end else if (trans == 1 && write == 0) begin
            case (mode)
                0: rdata <= waddr >> 1;
                1: rdata <= (waddr << 1) + waddr + 1;
            endcase
            readyout <= 1;
        end
    end

endmodule
