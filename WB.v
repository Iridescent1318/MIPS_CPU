module WB(
          iResult,
          iControlSignal,
          iReadData,
          iRegAddress,
          iPC_plus_4,
          oRegWrite,
          oRegData,
          oRegAddress
);

    input [31:0] iResult;
    input [31:0] iControlSignal;
    input [31:0] iReadData;
    input [4:0] iRegAddress;
    input [31:0] iPC_plus_4;
    output oRegWrite;
    output [31:0] oRegData;
    output [4:0] oRegAddress;
    
    assign oRegWrite = iControlSignal[8];
    
    assign oRegAddress = iRegAddress;
    
    assign oRegData = (iControlSignal[14:13] == 2'b10)? iPC_plus_4:
                      (iControlSignal[14:13] == 2'b01)? iReadData: iResult;
                      
endmodule