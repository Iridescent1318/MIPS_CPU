
module Control(OpCode, Funct,
	PCSrc, Branch, RegWrite, RegDst, 
	MemRead, MemWrite, MemtoReg, 
	ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUOp, 
	Branch_ne, Branch_lez, Branch_gtz, Branch_ltz, Exception, Interrupt);
	input [5:0] OpCode;
	input [5:0] Funct;
	input Interrupt;
	output [2:0] PCSrc;
	output Branch;
	output Branch_ne;
	output Branch_lez;
	output Branch_gtz;
	output Branch_ltz;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output [1:0] MemtoReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	output [3:0] ALUOp;
	output Exception;
	
	// 001: j, jal. Jump Target
	// 010: jr, jalr. Jump Register
	// 000: PC+4
	// 011: Exception 0x80000008
	// 100: Branch
	// 101: Interrupt 0x80000004
	assign PCSrc[2:0] = 
	    (Interrupt)? 3'b101:
		(OpCode == 6'h02 || OpCode == 6'h03)? 3'b001:
		(OpCode == 6'h0 && (Funct == 6'h08 || Funct == 6'h09))? 3'b010:
		(OpCode >= 6'h01 && OpCode <= 6'h07)? 3'b100:
		(OpCode == 6'h0e || OpCode == 6'h0d || 
			(OpCode > 6'h0f && OpCode != 6'h23 && OpCode != 6'h2b))? 3'b011:
		3'b000;
    
	assign Branch = 
		(OpCode == 6'h04)? 1:0;

	assign Branch_ne = 
		(OpCode == 6'h05)? 1:0;

	assign Branch_lez = 
		(OpCode == 6'h06)? 1:0;

	assign Branch_gtz = 
		(OpCode == 6'h07)? 1:0;

	assign Branch_ltz = 
		(OpCode == 6'h01)? 1:0;

	assign RegWrite = (Interrupt)? 1:
		(OpCode == 6'h2b || OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || 
		 OpCode == 6'h07 || OpCode == 6'h01 || OpCode == 6'h02 || (OpCode == 6'h0 && Funct == 6'h08))? 0:1;

	assign RegDst[1:0] = 
	    (Interrupt)? 2'b11:
		(OpCode == 6'h00)? 2'b01:
		(OpCode == 6'h03)? 2'b10:
		2'b00;

	assign MemRead = (Interrupt)? 0:
		(OpCode == 6'h23)? 1:0;

	assign MemWrite = (Interrupt)? 0:
		(OpCode == 6'h2b)? 1:0;

	assign MemtoReg[1:0] = (Interrupt)? 2'b10:
		(OpCode == 6'h03 || (OpCode == 6'h0 && Funct == 6'h09))? 2'b10:
		(OpCode == 6'h23)? 2'b01:2'b00;

	assign ALUSrc1 = 
		(OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03))? 1:0;

	assign ALUSrc2 = 
		(OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08 ||
		 OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b)? 1:0;

	assign ExtOp =
		(OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a ||
		 OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01)? 1:0;

	assign LuOp = 
		(OpCode == 6'h0f)? 1:0;
	// Your code above
	
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
		3'b000;
		
	assign ALUOp[3] = OpCode[0];
	
	assign Exception = (OpCode == 6'h0e || OpCode == 6'h0d || (OpCode > 6'h0f && OpCode != 6'h23 && OpCode != 6'h2b))? 1'b1 : 0;
	
endmodule