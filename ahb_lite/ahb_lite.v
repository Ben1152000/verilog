
module Controller #(parameter VALUE=1) (
    input               clock
,   input               rst_n
,   input               readyout
,   input       [7:0]   rdata
,   output reg          write
,   output reg          trans
,   output reg  [7:0]   waddr
,   output reg  [7:0]   wdata
,   output reg  [7:0]   value
);
    reg set;
    reg await;
    reg set_next;
    reg await_next;
    reg write_next;
    reg trans_next;
    reg [7:0] waddr_next;
    reg [7:0] wdata_next;
    reg [7:0] value_next;

    always @(posedge clock) begin
        if (~rst_n) begin
            write <= 1'b0;
            trans <= 1'b0;
            waddr <= 8'b0;
            wdata <= 8'b0;
            value <= VALUE;
            set   <= 1'b0;
            await <= 1'b0;
        end else begin
            write <= write_next;
            trans <= trans_next;
            waddr <= waddr_next;
            wdata <= wdata_next;
            value <= value_next;
            set   <= set_next;
            await <= await_next;
        end
    end

    always @* begin
        write_next = write;
        trans_next = trans;
        waddr_next = waddr;
        wdata_next = wdata;
        value_next = value;
        set_next   = set;
        await_next = await;

        if (~set) begin
            write_next = 1'b1;
            trans_next = 1'b1;
            waddr_next = 8'b0;
            if (await) begin
                value_next = rdata;
                wdata_next = rdata;
                await_next = 1'b0;
            end else begin
                wdata_next = value;
            end
            set_next = 1;
        end else if (set & ~await) begin
            write_next = 1'b0;
            trans_next = 1'b1;
            waddr_next = value;
            await_next = 1'b1;
        end else if (set & await) begin
            trans_next = 1'b0;
            set_next = 1'b0;
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
    input wire          clock
,   input wire          rst_n
,   input wire          write
,   input wire          trans
,   input wire  [7:0]   waddr
,   input wire  [7:0]   wdata
,   output reg          readyout
,   output reg  [7:0]   rdata
);
    reg mode;
    reg mode_next;
    reg readyout_next;
    reg rdata_next;

    always @(posedge clock) begin
        if (~rst_n) begin
            mode        <= 1'b0; // Begin in even mode.
            readyout    <= 1'b0;
            rdata       <= 8'b0;
        end else begin
            mode        <= mode_next;
            readyout    <= readyout_next;
            rdata       <= rdata_next;
        end
    end

    always @* begin
        mode_next = mode;
        readyout_next = readyout;
        rdata_next = rdata;

        if (~trans) begin
            readyout_next = 1'b0;
        end else if (trans & write) begin
            if (waddr == 8'b0)  // Update mode
                mode_next = wdata[0];
            rdata_next = wdata;
            readyout_next = 1'b1;
        end else if (trans & ~write) begin
            case (mode)
                1'b0: rdata_next = waddr >> 1;
                1'b1: rdata_next = (waddr << 1) + waddr + 8'b1;
            endcase
            readyout_next = 1'b1;
        end
    end

endmodule
