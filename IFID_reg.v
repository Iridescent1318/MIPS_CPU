`timescale 1ns / 1ps

module IFID_reg(
        clk,
        reset,
        iPC_plus_4,
        iInstruction,
        iIFID_write,
        iIFID_flush,
        iIDEX_flush,
        oPC_plus_4,
        oInstruction
    );
    
    input clk;
    input reset;
    input [31:0] iPC_plus_4;
    input [31:0] iInstruction;
    input iIFID_write;
    input iIFID_flush;
    input iIDEX_flush;
    output reg [31:0] oInstruction;
    output reg [31:0] oPC_plus_4;
    
    initial begin
    	oInstruction = 32'h00000000;
    	oPC_plus_4 = 32'h00000000;
    end

    always@(posedge clk or posedge reset)
    begin
        if(reset) begin
            oPC_plus_4 <= 32'h80000000;
            oInstruction <= 32'h00000000;
        end
        else
        begin
            if(iIFID_flush) begin
                if(iIDEX_flush)
                    oPC_plus_4 <= (iPC_plus_4[30:0] == 31'b0)? iPC_plus_4:
                                  (iPC_plus_4[30:0] == 31'h4)? iPC_plus_4 - 4: iPC_plus_4 - 8;
                else
                    oPC_plus_4 <= (iPC_plus_4[30:0] == 31'b0)? iPC_plus_4: iPC_plus_4 - 4;
                oInstruction <= 32'h0;
            end
            else
            if(iIFID_write == 1'b1) begin
                oPC_plus_4 <= iPC_plus_4;
                oInstruction <= iInstruction;
            end
        end
    end
endmodule
