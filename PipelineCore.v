`timescale 1ns / 1ps

module PipelineCore(
                    clk,
                    reset,
                    iInterrupt,
                    iAddress,
                    oData,
                    oCountStart,
                    oCountStop
);

    input clk, reset, iInterrupt;
    input  [6:0] iAddress;
    output [31:0] oData;
    output        oCountStart;
    output        oCountStop;
    
    
    wire FU_EXMEM_RegWrite;
    wire [4:0]  FU_EXMEM_RegWriteAddr;
    wire [4:0]  FU_IDEX_Rt;
    wire [4:0]  FU_IDEX_Rs;
    wire [2:0]  FU_ID_PCSrc;
    wire [4:0]  FU_IFID_Rs;
    wire [4:0]  FU_IDEX_RegWriteAddr;
    wire        FU_IDEX_RegWrite;
    wire        FU_MEMWB_RegWrite;
    wire [4:0]  FU_MEMWB_RegWriteAddr;
    wire [1:0]  FU_ForwardA;
    wire [1:0]  FU_ForwardB;
    wire [1:0]  FU_ForwardJ;
    
    wire        HU_IDEX_MemRead;
    wire [4:0]  HU_IDEX_Rt;
	wire [4:0]  HU_IFID_Rs;
	wire [4:0]  HU_IFID_Rt;
	wire [2:0]  HU_ID_PCSrc;
	wire [2:0]  HU_IDEX_PCSrc;
	wire        HU_EX_need_branch;
	wire        HU_PCWrite;
	wire        HU_IFID_write;
	wire        HU_IFID_flush;
	wire        HU_IDEX_flush;
	
	wire        PCMUX_iBranch;
	wire [2:0]  PCMUX_iPCSrc;
	wire [31:0] PCMUX_iJumpReg;
	wire [31:0] PCMUX_iJumpTgt;
	wire [31:0] PCMUX_iBranchTarget;
	wire [31:0] PCMUX_iPC_plus_4;
	wire [31:0] PCMUX_oPC_next;
	
	wire [1:0]  JRMUX_iEXForwardJ;
	wire [31:0] JRMUX_iIDRegReadData;
    wire [31:0] JRMUX_iEXALUResult;
	wire [31:0] JRMUX_iMEMReadData;
	wire [31:0] JRMUX_iWBRegWriteData;
	wire [31:0] JRMUX_oJumpReg;
     
    wire [31:0] IF_iPC_next;
    wire        IF_iPCWrite;
    wire [31:0] IF_oPC_plus_4;
    wire [31:0] IF_oInstruction;
    wire        IF_oInterrupt;
    
    wire [31:0] IFID_iPC_plus_4;
    wire [31:0] IFID_iInstruction;
    wire        IFID_iIFID_write, IFID_iIFID_flush, IFID_iIDEX_flush;
    wire [31:0] IFID_oPC_plus_4;
    wire [31:0] IFID_oInstruction;
    
    wire [31:0] ID_iInstruction;
    wire        ID_iWB_RegWrite;
    wire [31:0] ID_iWB_WriteData;
    wire [4:0]  ID_iWB_WriteAddress;
    wire [31:0] ID_iPC_plus_4;
    wire [31:0] ID_oDatabusA;
    wire [31:0] ID_oDatabusB;
    wire [31:0] ID_oDatabusC;
    wire [31:0] ID_oControlSignal;
    wire [4:0]  ID_oRegAddress;
    wire [15:0] ID_oOffset;
    wire [31:0] ID_oPC_plus_4;
    wire [31:0] ID_oInstruction;
    
    wire [31:0] IDEX_iDatabusA;
    wire [31:0] IDEX_iDatabusB;
    wire [31:0] IDEX_iDatabusC;
    wire [31:0] IDEX_iControlSignal;
    wire [4:0]  IDEX_iRegAddress;
    wire [15:0] IDEX_iOffset;
    wire [31:0] IDEX_iPC_plus_4;
    wire [31:0] IDEX_iInstruction;
    wire        IDEX_iflush;
    wire [31:0] IDEX_oDatabusA;
    wire [31:0] IDEX_oDatabusB;
    wire [31:0] IDEX_oDatabusC;
    wire [31:0] IDEX_oControlSignal;
    wire [4:0]  IDEX_oRegAddress;
    wire [15:0] IDEX_oOffset;
    wire [31:0] IDEX_oPC_plus_4;
    wire [4:0]  IDEX_oRt, IDEX_oRs;
    wire [31:0] IDEX_oInstruction;

    wire [31:0] EX_iDatabusA;
    wire [31:0] EX_iDatabusB;
    wire [31:0] EX_iDatabusC;
    wire [31:0] EX_iControlSignal;
    wire [4:0]  EX_iRegAddress;
    wire [15:0] EX_iOffset;
    wire [31:0] EX_iPC_plus_4;
    wire [31:0] EX_iEXMEM_forward_data;
    wire [31:0] EX_iMEMWB_forward_data;
    wire [1:0]  EX_iForwardA;
    wire [1:0]  EX_iForwardB;
    wire [31:0] EX_iInstruction;
    wire [31:0] EX_oBranchTarget;
    wire        EX_oBranchJudge;
    wire [31:0] EX_oResult;
    wire [31:0] EX_oControlSignal;
    wire [31:0] EX_oDatabusB;
    wire [4:0]  EX_oRegAddress;
    wire [31:0] EX_oPC_plus_4;
    
    wire [31:0] EXMEM_iResult;
    wire [31:0] EXMEM_iControlSignal;
    wire [31:0] EXMEM_iDatabusB;
    wire [4:0]  EXMEM_iRegAddress;
    wire [31:0] EXMEM_iPC_plus_4;
    wire [31:0] EXMEM_oResult;
    wire [31:0] EXMEM_oControlSignal;
    wire [31:0] EXMEM_oDatabusB;
    wire [4:0]  EXMEM_oRegAddress;
    wire [31:0] EXMEM_oPC_plus_4;
    
    wire [31:0] MEM_iResult;
    wire [31:0] MEM_iControlSignal;
    wire [4:0]  MEM_iRegAddress;
    wire [31:0] MEM_iDatabusB;
    wire [31:0] MEM_iPC_plus_4;
    wire [31:0] MEM_oResult;
    wire [31:0] MEM_oControlSignal;
    wire [4:0]  MEM_oRegAddress;
    wire [31:0] MEM_oReadData;
    wire [31:0] MEM_oPC_plus_4;
    
    wire [31:0] MEMWB_iResult;
    wire [31:0] MEMWB_iControlSignal;
    wire [31:0] MEMWB_iReadData;
    wire [4:0]  MEMWB_iRegAddress;
    wire [31:0] MEMWB_iPC_plus_4;
    wire [31:0] MEMWB_oResult;
    wire [31:0] MEMWB_oControlSignal;
    wire [31:0] MEMWB_oReadData;
    wire [4:0]  MEMWB_oRegAddress;
    wire [31:0] MEMWB_oPC_plus_4;
    
    wire [31:0] WB_iResult;
    wire [31:0] WB_iControlSignal;
    wire [31:0] WB_iReadData;
    wire [4:0]  WB_iRegAddress;
    wire [31:0] WB_iPC_plus_4;
    wire        WB_oRegWrite;
    wire [31:0] WB_oRegData;
    wire [4:0]  WB_oRegAddress;

    assign IF_iPC_next = PCMUX_oPC_next;
    assign IF_iPCWrite = HU_PCWrite;

    IF IF0(.clk(clk),
           .reset(reset),
           .iPC_next(IF_iPC_next),
           .iPCWrite(IF_iPCWrite),
           .iInterrupt(iInterrupt),
           .oPC_plus_4(IF_oPC_plus_4),
           .oInstruction(IF_oInstruction),
           .oInterrupt(IF_oInterrupt));
    

    assign IFID_iPC_plus_4 = IF_oPC_plus_4;
    assign IFID_iInstruction = IF_oInstruction;
    assign IFID_iIFID_write = HU_IFID_write;
    assign IFID_iIFID_flush = HU_IFID_flush;
    assign IFID_iIDEX_flush = HU_IDEX_flush;

    IFID_reg IFID_reg0(.clk(clk),
                       .reset(reset),
                       .iPC_plus_4(IFID_iPC_plus_4),
                       .iInstruction(IFID_iInstruction),
                       .iIFID_write(IFID_iIFID_write),
                       .iIFID_flush(IFID_iIFID_flush),
                       .iIDEX_flush(IFID_iIDEX_flush),
                       .oPC_plus_4(IFID_oPC_plus_4),
                       .oInstruction(IFID_oInstruction));

    assign ID_iInstruction = IFID_oInstruction;
    assign ID_iWB_RegWrite = WB_oRegWrite;
    assign ID_iWB_WriteData = WB_oRegData;
    assign ID_iWB_WriteAddress = WB_oRegAddress;
    assign ID_iPC_plus_4 = IFID_oPC_plus_4;
    
    ID ID0(.clk(clk),
           .reset(reset),
           .iInstruction(ID_iInstruction),
           .iWB_RegWrite(ID_iWB_RegWrite),
           .iWB_WriteData(ID_iWB_WriteData),
           .iWB_WriteAddress(ID_iWB_WriteAddress),
           .iPC_plus_4(ID_iPC_plus_4),
           .iInterrupt(IF_oInterrupt),
           .oDatabusA(ID_oDatabusA),
           .oDatabusB(ID_oDatabusB),
           .oDatabusC(ID_oDatabusC),
           .oControlSignal(ID_oControlSignal),
           .oRegAddress(ID_oRegAddress),
           .oOffset(ID_oOffset),
           .oPC_plus_4(ID_oPC_plus_4),
           .oInstruction(ID_oInstruction));
    
    assign IDEX_iDatabusA = ID_oDatabusA;
    assign IDEX_iDatabusB = ID_oDatabusB;
    assign IDEX_iDatabusC = ID_oDatabusC;
    assign IDEX_iControlSignal = ID_oControlSignal;
    assign IDEX_iRegAddress = ID_oRegAddress;
    assign IDEX_iOffset = ID_oOffset;
    assign IDEX_iPC_plus_4 = ID_oPC_plus_4;
    assign IDEX_iInstruction = ID_oInstruction;
    assign IDEX_iflush = HU_IDEX_flush;

    IDEX_reg IDEX_reg0(.clk(clk),
                       .reset(reset),
                       .iDatabusA(IDEX_iDatabusA),
                       .iDatabusB(IDEX_iDatabusB),
                       .iDatabusC(IDEX_iDatabusC),
                       .iControlSignal(IDEX_iControlSignal),
                       .iRegAddress(IDEX_iRegAddress),
                       .iOffset(IDEX_iOffset),
                       .iPC_plus_4(IDEX_iPC_plus_4),
                       .iFlush(IDEX_iflush),
                       .iInstruction(IDEX_iInstruction),
                       .oDatabusA(IDEX_oDatabusA),
                       .oDatabusB(IDEX_oDatabusB),
                       .oDatabusC(IDEX_oDatabusC),
                       .oControlSignal(IDEX_oControlSignal),
                       .oRegAddress(IDEX_oRegAddress),
                       .oOffset(IDEX_oOffset),
                       .oPC_plus_4(IDEX_oPC_plus_4),
                       .oInstruction(IDEX_oInstruction));

    assign EX_iDatabusA = IDEX_oDatabusA;
    assign EX_iDatabusB = IDEX_oDatabusB;
    assign EX_iDatabusC = IDEX_oDatabusC;
    assign EX_iControlSignal = IDEX_oControlSignal;
    assign EX_iRegAddress = IDEX_oRegAddress;
    assign EX_iOffset = IDEX_oOffset;
    assign EX_iPC_plus_4 = IDEX_oPC_plus_4;
    assign EX_iEXMEM_forward_data = EXMEM_oResult;
    assign EX_iMEMWB_forward_data = WB_oRegData;
    assign EX_iForwardA = FU_ForwardA;
    assign EX_iForwardB = FU_ForwardB;
    assign EX_iInstruction = IDEX_oInstruction;
    
    EX EX0(.clk(clk),
           .reset(reset),
           .iDatabusA(EX_iDatabusA),
           .iDatabusB(EX_iDatabusB),
           .iDatabusC(EX_iDatabusC),
           .iControlSignal(EX_iControlSignal),
           .iRegAddress(EX_iRegAddress),
           .iOffset(EX_iOffset),
           .iPC_plus_4(EX_iPC_plus_4),
           .iEXMEM_forward_data(EX_iEXMEM_forward_data),
           .iMEMWB_forward_data(EX_iMEMWB_forward_data),
           .iForwardA(EX_iForwardA),
           .iForwardB(EX_iForwardB),
           .iInstruction(EX_iInstruction),
           .oBranchTarget(EX_oBranchTarget),           
           .oBranchJudge(EX_oBranchJudge),
           .oResult(EX_oResult),
           .oControlSignal(EX_oControlSignal),
           .oDatabusB(EX_oDatabusB),
           .oRegAddress(EX_oRegAddress),
           .oPC_plus_4(EX_oPC_plus_4)); 
    
    assign EXMEM_iResult = EX_oResult;
    assign EXMEM_iControlSignal = EX_oControlSignal;
    assign EXMEM_iDatabusB = EX_oDatabusB;
    assign EXMEM_iRegAddress = EX_oRegAddress;
    assign EXMEM_iPC_plus_4 = EX_oPC_plus_4;

    EXMEM_reg EXMEM_reg0(.clk(clk),
                 .reset(reset),
                 .iResult(EXMEM_iResult),
                 .iControlSignal(EXMEM_iControlSignal),
                 .iDatabusB(EXMEM_iDatabusB),
                 .iRegAddress(EXMEM_iRegAddress),
                 .iPC_plus_4(EXMEM_iPC_plus_4),
                 .oResult(EXMEM_oResult),
                 .oControlSignal(EXMEM_oControlSignal),
                 .oDatabusB(EXMEM_oDatabusB),
                 .oRegAddress(EXMEM_oRegAddress),
                 .oPC_plus_4(EXMEM_oPC_plus_4));

    assign MEM_iResult = EXMEM_oResult;
    assign MEM_iControlSignal = EXMEM_oControlSignal;
    assign MEM_iRegAddress = EXMEM_oRegAddress;
    assign MEM_iDatabusB = EXMEM_oDatabusB;
    assign MEM_iPC_plus_4 = EXMEM_oPC_plus_4;
    
    MEM MEM0(.clk(clk),
             .reset(reset),
             .iResult(MEM_iResult),
             .iControlSignal(MEM_iControlSignal),
             .iDatabusB(MEM_iDatabusB),
             .iRegAddress(MEM_iRegAddress),
             .iPC_plus_4(MEM_iPC_plus_4),
             .oResult(MEM_oResult),
             .oControlSignal(MEM_oControlSignal),
             .oRegAddress(MEM_oRegAddress),
             .oReadData(MEM_oReadData),
             .oPC_plus_4(MEM_oPC_plus_4));

    assign MEMWB_iResult = MEM_oResult;
    assign MEMWB_iControlSignal = MEM_oControlSignal;
    assign MEMWB_iReadData = MEM_oReadData;
    assign MEMWB_iRegAddress = MEM_oRegAddress;
    assign MEMWB_iPC_plus_4 = MEM_oPC_plus_4;

    MEMWB_reg MEMWB_reg0(.clk(clk),
                 .reset(reset),
                 .iResult(MEMWB_iResult),
                 .iControlSignal(MEMWB_iControlSignal),
                 .iRegAddress(MEMWB_iRegAddress),
                 .iReadData(MEMWB_iReadData),
                 .iPC_plus_4(MEMWB_iPC_plus_4),
                 .oResult(MEMWB_oResult),
                 .oControlSignal(MEMWB_oControlSignal),
                 .oRegAddress(MEMWB_oRegAddress),
                 .oReadData(MEMWB_oReadData),
                 .oPC_plus_4(MEMWB_oPC_plus_4));                

    assign WB_iResult = MEMWB_oResult;
    assign WB_iControlSignal = MEMWB_oControlSignal;
    assign WB_iReadData = MEMWB_oReadData;
    assign WB_iRegAddress = MEMWB_oRegAddress;
    assign WB_iPC_plus_4 = MEMWB_oPC_plus_4;

    WB WB0(.iResult(WB_iResult),
           .iControlSignal(WB_iControlSignal),
           .iReadData(WB_iReadData),
           .iRegAddress(WB_iRegAddress),
           .iPC_plus_4(WB_iPC_plus_4),
           .oRegWrite(WB_oRegWrite),
           .oRegData(WB_oRegData),
           .oRegAddress(WB_oRegAddress));
           
	assign FU_EXMEM_RegWrite = EXMEM_oControlSignal[8];
	assign FU_EXMEM_RegWriteAddr = EXMEM_oRegAddress;
	assign FU_IDEX_Rt = IDEX_oInstruction[20:16];
	assign FU_IDEX_Rs = IDEX_oInstruction[25:21];
	assign FU_ID_PCSrc = ID_oControlSignal[2:0];
	assign FU_IFID_Rs = IFID_oInstruction[25:21];
	assign FU_IDEX_RegWriteAddr = IDEX_oRegAddress;
	assign FU_IDEX_RegWrite = IDEX_oControlSignal[8];
	assign FU_MEMWB_RegWrite = MEMWB_oControlSignal[8];
	assign FU_MEMWB_RegWriteAddr = MEMWB_oRegAddress;

    ForwardUnit ForwardUnit0(.EXMEM_RegWrite(FU_EXMEM_RegWrite),
                             .EXMEM_RegWriteAddr(FU_EXMEM_RegWriteAddr),
                             .IDEX_Rt(FU_IDEX_Rt),
                             .IDEX_Rs(FU_IDEX_Rs),
                             .ID_PCSrc(FU_ID_PCSrc),
                             .IFID_Rs(FU_IFID_Rs),
                             .IDEX_RegWriteAddr(FU_IDEX_RegWriteAddr),
                             .IDEX_RegWrite(FU_IDEX_RegWrite),
                             .MEMWB_RegWrite(FU_MEMWB_RegWrite),
                             .MEMWB_RegWriteAddr(FU_MEMWB_RegWriteAddr),
                             .ForwardA(FU_ForwardA),
                             .ForwardB(FU_ForwardB),
                             .ForwardJ(FU_ForwardJ)); // Register Problem Remained.

    assign HU_IDEX_MemRead = IDEX_oControlSignal[11];
    assign HU_IDEX_Rt = IDEX_oInstruction[20:16];
    assign HU_IFID_Rs = IFID_oInstruction[25:21];
    assign HU_IFID_Rt = IFID_oInstruction[20:16];
    assign HU_ID_PCSrc = ID_oControlSignal[2:0];
    assign HU_IDEX_PCSrc = IDEX_oControlSignal[2:0];
    assign HU_EX_need_branch = EX_oBranchJudge;

    HazardUnit HazardUnit0(.IDEX_MemRead(HU_IDEX_MemRead),
				           .IDEX_Rt(HU_IDEX_Rt),
				           .IFID_Rs(HU_IFID_Rs),
				           .IFID_Rt(HU_IFID_Rt),
				           .ID_PCSrc(HU_ID_PCSrc),
				           .IDEX_PCSrc(HU_IDEX_PCSrc),
				           .EX_need_branch(HU_EX_need_branch),
				           .PCWrite(HU_PCWrite),
				           .IFID_write(HU_IFID_write),
				           .IFID_flush(HU_IFID_flush),
				           .IDEX_flush(HU_IDEX_flush));

    assign JRMUX_iEXForwardJ = FU_ForwardJ;
    assign JRMUX_iIDRegReadData = {1'b0, ID_oDatabusA[30:0]};
    assign JRMUX_iEXALUResult = {1'b0, EX_oResult[30:0]};
    assign JRMUX_iMEMReadData = {1'b0, MEM_oReadData[30:0]};
    assign JRMUX_iWBRegWriteData = {1'b0, WB_oRegData[30:0]};

    JumpRegMUX JumpRegMUX0(.iEXForwardJ(JRMUX_iEXForwardJ),
    					   .iIDRegReadData(JRMUX_iIDRegReadData),
    					   .iEXALUResult(JRMUX_iEXALUResult),
						   .iMEMReadData(JRMUX_iMEMReadData),
			 			   .iWBRegWriteData(JRMUX_iWBRegWriteData),
			               .oJumpReg(JRMUX_oJumpReg));

    assign PCMUX_iBranch = EX_oBranchJudge;
    assign PCMUX_iPCSrc = (EX_oControlSignal[2:0] == 3'b100 && EX_oBranchJudge) ? 3'b100 : 
    			   		  (ID_oControlSignal[2:0] == 3'b100 ? 3'b000 : ID_oControlSignal[2:0]);
    assign PCMUX_iJumpReg = JRMUX_oJumpReg;
    assign PCMUX_iJumpTgt = {ID0.iPC_plus_4[31:28],ID0.iInstruction[25:0],2'b00};
    assign PCMUX_iBranchTarget = EX_oBranchTarget;
    assign PCMUX_iPC_plus_4 = IF_oPC_plus_4;

    PCMUX PCMUX0(.iBranch(PCMUX_iBranch),
				 .iPCSrc(PCMUX_iPCSrc),
				 .iJumpReg(PCMUX_iJumpReg),
				 .iJumpTgt(PCMUX_iJumpTgt),
				 .iBranchTarget(PCMUX_iBranchTarget),
				 .iPC_plus_4(PCMUX_iPC_plus_4),
				 .oPC_next(PCMUX_oPC_next)
    	);
    
    assign oData = MEM0.DataMemory0.RAM_data[iAddress];
    assign oCountStart = (IF0.PC[15:0] == 16'h000c)? 1'b1:1'b0;
    assign oCountStop  = (IF0.PC[15:0] == 16'h0064)? 1'b1:1'b0;
    
endmodule
