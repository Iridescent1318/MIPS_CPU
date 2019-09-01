module MEM(
           clk,
           reset,
           iResult,
           iControlSignal,
           iDatabusB,
           iRegAddress,
           iPC_plus_4,
           oResult,
           oControlSignal,
           oRegAddress,
           oReadData,
           oPC_plus_4
);

    input clk, reset;
    input [31:0] iResult;
    input [31:0] iControlSignal;
    input [31:0] iDatabusB;
    input [4:0] iRegAddress;
    input [31:0] iPC_plus_4;
    output [31:0] oResult;
    output [31:0] oControlSignal;
    output [4:0] oRegAddress;
    output [31:0] oReadData;
    output [31:0] oPC_plus_4;
    
    DataMemory DataMemory0(.reset(reset),
                           .clk(clk),
                           .Address(iResult),
                           .Write_data(iDatabusB),
                           .Read_data(oReadData),
                           .MemRead(iControlSignal[11]),
                           .MemWrite(iControlSignal[12]));
    
    assign oResult = iResult;
    
    assign oControlSignal = iControlSignal;
    
    assign oRegAddress = iRegAddress;
    
    assign oPC_plus_4 = iPC_plus_4;
    
endmodule