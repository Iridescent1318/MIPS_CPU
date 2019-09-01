module IDEX_reg(
            clk,
            reset,
            iDatabusA,
            iDatabusB,
            iDatabusC,
            iControlSignal,
            iRegAddress,
            iOffset,
            iPC_plus_4,
            iFlush,
            iInstruction,
            oDatabusA,
            oDatabusB,
            oDatabusC,
            oControlSignal,
            oRegAddress,
            oOffset,
            oPC_plus_4,
            oInstruction
);
    input clk, reset;
    input [31:0] iDatabusA;
    input [31:0] iDatabusB;
    input [31:0] iDatabusC;
    input [31:0] iControlSignal;
    input [4:0] iRegAddress;
    input [15:0] iOffset;
    input [31:0] iPC_plus_4;
    input iFlush;
    input [31:0] iInstruction;
    output reg [31:0] oDatabusA;
    output reg [31:0] oDatabusB;
    output reg [31:0] oDatabusC;
    output reg [31:0] oControlSignal;
    output reg [4:0] oRegAddress;
    output reg [15:0] oOffset;
    output reg [31:0] oPC_plus_4;
    output reg [31:0] oInstruction;

    initial begin
    	oDatabusA = 32'h00000000;
    	oDatabusB = 32'h00000000;
    	oDatabusC = 32'h00000000;
    	oControlSignal = 32'h00000000;
    	oRegAddress = 5'b0;
    	oOffset = 16'b0;
    	oPC_plus_4 = 32'h00000000;
    	oInstruction = 32'b0;
    end
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            oDatabusA <= 32'd0;
            oDatabusB <= 32'd0;
            oDatabusC <= 32'd0;
            oControlSignal <= 32'd0;
            oRegAddress <= 5'd0;
            oOffset <= 16'd0;
            oPC_plus_4 <= 32'h80000000;
            oInstruction <= 32'b0;
        end
        else begin
            if(iFlush) begin
                oDatabusA <= 32'h00000000;
                oDatabusB <= 32'h00000000;
                oDatabusC <= 32'h00000000;
                oControlSignal <= 32'h00000000;
                oRegAddress <= 5'b0;
                oOffset <= 16'b0;
                oPC_plus_4 <= (iPC_plus_4[30:0] == 31'b0)? iPC_plus_4: iPC_plus_4 - 4; // Preventing from overflow
                oInstruction <= 32'b0;
            end
            else begin
                oDatabusA <= iDatabusA;
                oDatabusB <= iDatabusB;
                oDatabusC <= iDatabusC;
                oControlSignal <= iControlSignal;
                oRegAddress <= iRegAddress;
                oOffset <= iOffset;
                oPC_plus_4 <= iPC_plus_4;
                oInstruction <= iInstruction;
            end
        end
    end
    
endmodule