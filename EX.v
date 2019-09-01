module EX(
          clk,
          reset,
          iDatabusA,
          iDatabusB,
          iDatabusC,
          iControlSignal,
          iRegAddress,
          iOffset,
          iPC_plus_4,
          iEXMEM_forward_data,
          iMEMWB_forward_data,
          iForwardA,
          iForwardB,
          iInstruction,
          oBranchTarget,
          oBranchJudge,
          oResult,
          oControlSignal,
          oDatabusB,
          oRegAddress,
          oPC_plus_4
);

    input clk, reset;
    input [31:0] iDatabusA;
    input [31:0] iDatabusB;
    input [31:0] iDatabusC;
    input [31:0] iControlSignal;
    input [4:0] iRegAddress;
    input [15:0] iOffset;
    input [31:0] iPC_plus_4;
    input [31:0] iEXMEM_forward_data;
    input [31:0] iMEMWB_forward_data;
    input [1:0] iForwardA;
    input [1:0] iForwardB;
    input [31:0] iInstruction;
    output [31:0] oBranchTarget;
    output oBranchJudge;
    output [31:0] oResult;
    output [31:0] oControlSignal;
    output [31:0] oDatabusB;
    output [4:0] oRegAddress;
    output [31:0] oPC_plus_4;

    wire [4:0] ALUCtl;
    wire Sign;

    ALUControl ALUControl0(.ALUOp(iControlSignal[21:19]),
                           //.Funct(iControlSignal[5:0]),
                           // ¡ü Big Mistake
                           .Funct(iInstruction[5:0]),
                           .ALUCtl(ALUCtl),
                           .Sign(Sign));
    
    wire [31:0] FA, FB;
    assign FA = (iForwardA == 2'b10)? iEXMEM_forward_data:
                 (iForwardA == 2'b01)? iMEMWB_forward_data:
                 iDatabusA;
    assign FB = (iForwardB == 2'b10)? iEXMEM_forward_data:
                 (iForwardB == 2'b01)? iMEMWB_forward_data:
                 iDatabusB;
    
    wire [31:0] iALU1, iALU2;
    assign iALU1 = FA;
    assign iALU2 = iControlSignal[16]? iDatabusC: FB;
    
    wire zero, gtz, ltz;
    ALU ALU0(.in1(iALU1),
             .in2(iALU2),
             .ALUCtl(ALUCtl),
             .Sign(Sign),
             .out(oResult),
             .zero(zero),
             .gtz(gtz),
             .ltz(ltz));
    
    assign oBranchTarget = {iPC_plus_4[31], (iPC_plus_4[30:0] + {13'b0, iOffset, 2'b00}) };
    
    assign oBranchJudge = ((iControlSignal[3] && zero)  || //beq
                           (iControlSignal[4] && ~zero) || //bne
                           (iControlSignal[5] && ~gtz)  || //blez
                           (iControlSignal[6] && gtz)   || //gtz
                           (iControlSignal[7] && ltz))? 1'b1:0; //bltz
    
    assign oControlSignal = iControlSignal;
    
    assign oDatabusB = FB;
    
    assign oRegAddress = iControlSignal[8]? iRegAddress: 5'b0;
    
    assign oPC_plus_4 = iPC_plus_4;

endmodule