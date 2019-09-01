module EXMEM_reg(
                 clk,
                 reset,
                 iResult,
                 iControlSignal,
                 iDatabusB,
                 iRegAddress,
                 iPC_plus_4,
                 oResult,
                 oControlSignal,
                 oDatabusB,
                 oRegAddress,
                 oPC_plus_4
);
    
    input clk, reset;
    input [31:0] iResult;
    input [31:0] iControlSignal;
    input [31:0] iDatabusB;
    input [4:0] iRegAddress;
    input [31:0] iPC_plus_4;
    output reg [31:0] oResult;
    output reg [31:0] oControlSignal;
    output reg [31:0] oDatabusB;
    output reg [4:0] oRegAddress;
    output reg [31:0] oPC_plus_4;

    initial begin
    	oResult = 32'h00000000;
    	oControlSignal = 32'h00000000;
    	oDatabusB = 32'h00000000;
    	oRegAddress = 5'b0;
    	oPC_plus_4 = 32'h00000000;
    end
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            oResult <= 32'b0;
            oControlSignal <= 32'b0;
            oDatabusB <= 32'b0;
            oRegAddress <= 5'b0;
            oPC_plus_4 <= 32'h80000000;
        end
        else
        begin
            oResult <= iResult;
            oControlSignal <= iControlSignal;
            oDatabusB <= iDatabusB;
            oRegAddress <= iRegAddress;
            oPC_plus_4 <= iPC_plus_4;
        end
    end
endmodule