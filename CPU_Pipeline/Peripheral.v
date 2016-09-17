`timescale 1ns/1ps



//LED, switch, ????????????????I/O

module Peripheral (reset, clk, rd, wr, addr, wdata, rdata,

    led, switch, digi, irqout);

    input reset, clk;

    input rd, wr;

    input [31:0] addr;      //??????

    input [31:0] wdata;

    output [31:0] rdata;

    reg [31:0] rdata;

    

//LED

    output [7:0] led;

    reg [7:0] led;

//switch

    input [7:0] switch;

//digi

    output [11:0] digi;

    reg [11:0] digi;    //digi[0:7] CA~CG?DP??????, digi[8:11] AN0~AN3???????



//timer

    reg [31:0] TH,TL;

    reg [2:0] TCON;

    output irqout;

    assign irqout = TCON[2];    //???????



    always@(*) begin

        if(rd) begin

            case(addr)

                32'h4000_0000: rdata = TH;

                32'h4000_0004: rdata = TL;

                32'h4000_0008: rdata = {29'b0, TCON};

                32'h4000_000C: rdata = {24'b0, led};

                32'h4000_0010: rdata = {24'b0, switch};

                32'h4000_0014: rdata = {20'b0, digi};

                default: rdata = 32'b0;

            endcase

        end

        else

            rdata = 32'b0;

    end



    always@(negedge reset or posedge clk) begin

        if(~reset) begin

            TH <= 32'b0;

            TL <= 32'b0;

            TCON <= 3'b0;

        end

        else begin

            if(TCON[0]) begin    //timer is enabled

                if(TL==32'hffffffff) begin

                    TL <= TH;   //????TH???32'hffffffff

                    if(TCON[1]) TCON[2] <= 1'b1;        //irq is enabled

                end

                else TL <= TL + 1;

            end

            

            if(wr) begin

                case(addr)

                    32'h4000_0000: TH <= wdata;

                    32'h4000_0004: TL <= wdata;

                    32'h4000_0008: TCON <= wdata[2:0];

                    32'h4000_000C: led <= wdata[7:0];

                    32'h4000_0014: digi <= wdata[11:0];

                    default: ;

                endcase

            end

        end

    end

endmodule


