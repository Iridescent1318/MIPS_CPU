module JumpRegMUX(
			 iEXForwardJ,
			 iIDRegReadData,
			 iEXALUResult,
			 iMEMReadData,
			 iWBRegWriteData,
			 oJumpReg
);
	input [1:0] iEXForwardJ;
	input [31:0] iIDRegReadData;
	input [31:0] iEXALUResult;
	input [31:0] iMEMReadData;
	input [31:0] iWBRegWriteData;
	output [31:0] oJumpReg;

	assign oJumpReg = (iEXForwardJ == 2'b00)? iIDRegReadData:
					  (iEXForwardJ == 2'b01)? iEXALUResult:
					  (iEXForwardJ == 2'b10)? iMEMReadData:
					  iWBRegWriteData;

endmodule