module ID(
        clk,
        reset,
        iInstruction,
        iWB_RegWrite,
        iWB_WriteData,
        iWB_WriteAddress,
        iPC_plus_4,
        iInterrupt,
        oDatabusA,
        oDatabusB,
        oDatabusC,
        oControlSignal,
        oRegAddress,
        oOffset,
        oPC_plus_4,
        oInstruction
);

    input clk;
    input reset;
    input [31:0] iInstruction;
    input iWB_RegWrite;
    input [31:0] iWB_WriteData;
    input [4:0] iWB_WriteAddress;
    input [31:0] iPC_plus_4;
    input iInterrupt;
    output [31:0] oDatabusA;
    output [31:0] oDatabusB;
    output [31:0] oDatabusC;
    output [31:0] oControlSignal;
    output [4:0] oRegAddress;
    output [15:0] oOffset;
    output [31:0] oPC_plus_4;
    output [31:0] oInstruction;
     
    wire [31:0] Read_data1;
    
    Control Control0(.OpCode(iInstruction[31:26]),
                     .Funct(iInstruction[5:0]),
                     .PCSrc(oControlSignal[2:0]),
                     .Branch(oControlSignal[3]),
                     .Branch_ne(oControlSignal[4]),
                     .Branch_lez(oControlSignal[5]),
                     .Branch_gtz(oControlSignal[6]),
                     .Branch_ltz(oControlSignal[7]),
                     .RegWrite(oControlSignal[8]),
                     .RegDst(oControlSignal[10:9]),
                     .MemRead(oControlSignal[11]),
                     .MemWrite(oControlSignal[12]),
                     .MemtoReg(oControlSignal[14:13]),
                     .ALUSrc1(oControlSignal[15]),
                     .ALUSrc2(oControlSignal[16]),
                     .ExtOp(oControlSignal[17]),
                     .LuOp(oControlSignal[18]),
                     .ALUOp(oControlSignal[21:19]),
                     .Exception(oControlSignal[22]),
                     .Interrupt(iInterrupt));
    
    RegisterFile RegisterFile0(.reset(reset),
                               .clk(clk),
                               .RegWrite(Control0.RegWrite || iWB_RegWrite),
                               .Read_register1(iInstruction[25:21]),
                               .Read_register2(iInstruction[20:16]),
                               .Write_register(iWB_WriteAddress),
                               .Write_data(iWB_WriteData),
                               .Read_data1(Read_data1),
                               .Read_data2(oDatabusB));
    
    wire [31:0] Ext_out;
	assign Ext_out = {Control0.ExtOp? {16{iInstruction[15]}}: 16'h0000, iInstruction[15:0]};
                         
    assign oRegAddress = (Control0.RegDst == 2'b01)? iInstruction[15:11]:
                         (Control0.RegDst == 2'b10)? 5'b11111:
                         (Control0.RegDst == 2'b00)? iInstruction[20:16]:
                         5'd26;
    assign oOffset = iInstruction[15:0];
    assign oPC_plus_4 = iPC_plus_4;
    assign oInstruction = iInstruction;
    
    assign oDatabusA = Control0.ALUSrc1? {27'b0, iInstruction[10:6]}: Read_data1;
    assign oDatabusC = Control0.LuOp? {iInstruction[15:0], 16'h0000}: Ext_out;                       

endmodule