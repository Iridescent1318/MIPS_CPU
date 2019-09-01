module PCMUX(
		     iBranch,
			 iPCSrc,
			 iJumpReg,
			 iJumpTgt,
			 iBranchTarget,
			 iPC_plus_4,
			 oPC_next
);
	
	input iBranch;
	input [2:0] iPCSrc;
	input [31:0] iJumpReg;
	input [31:0] iJumpTgt;
	input [31:0] iBranchTarget;
	input [31:0] iPC_plus_4;
	output [31:0] oPC_next;

    // 001: j, jal. Jump Target
	// 010: jr, jalr. Jump Register
	// 000: PC+4
	// 011: Exception 0x80000008
	// 100: Branch
	// 101: Interrupt 0x80000004
	
	assign oPC_next = (iPCSrc == 3'b011)? 32'h80000008:
					  (iPCSrc == 3'b100)? iBranchTarget:
					  (iPCSrc == 3'b001)? iJumpTgt:
					  (iPCSrc == 3'b010)? iJumpReg:
					  (iPCSrc == 3'b101)? 32'h80000004:
					  iPC_plus_4;

endmodule