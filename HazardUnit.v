`timescale 1ns / 1ps

module HazardUnit(
				  IDEX_MemRead,
				  IDEX_Rt,
				  IFID_Rs,
				  IFID_Rt,
				  ID_PCSrc,
				  IDEX_PCSrc,
				  EX_need_branch,
				  PCWrite,
				  IFID_write,
				  IFID_flush,
				  IDEX_flush
);
	input IDEX_MemRead;
	input [4:0] IDEX_Rt;
	input [4:0] IFID_Rs;
	input [4:0] IFID_Rt;
	input [2:0] ID_PCSrc;
	input [2:0] IDEX_PCSrc;
	input EX_need_branch;
	output PCWrite;
	output IFID_write;
	output IFID_flush;
	output IDEX_flush;

	reg [2:0] PCWrite_request, IFID_write_request, IFID_flush_request, IDEX_flush_request;

	assign PCWrite = PCWrite_request[0] & PCWrite_request[1] & PCWrite_request[2];
	assign IFID_write = IFID_write_request[0] & IFID_write_request[1] & IFID_write_request[2];
	assign IFID_flush = IFID_flush_request[0] | IFID_flush_request[1] | IFID_flush_request[2];
	assign IDEX_flush = IDEX_flush_request[0] | IDEX_flush_request[1] | IDEX_flush_request[2];

    // Load-use
	always @(*) begin
		if(IDEX_MemRead == 1'b1 &&
		   (IDEX_Rt == IFID_Rs || IDEX_Rt == IFID_Rt)) 
			begin
		   		PCWrite_request[0] = 1'b0;
		   		IFID_write_request[0] = 1'b0;
		   		IDEX_flush_request[0] = 1'b1;
		   		IFID_flush_request[0] = 1'b0;
			end
		else
			begin
		   		PCWrite_request[0] = 1'b1;
		   		IFID_write_request[0] = 1'b1;
		   		IDEX_flush_request[0] = 1'b0;
		   		IFID_flush_request[0] = 1'b0;
			end
	end

    // Jump
	always @(*) begin
		if(ID_PCSrc == 3'b001 || ID_PCSrc == 3'b010 || ID_PCSrc == 3'b011 || ID_PCSrc == 3'b101) 
			begin
		   		PCWrite_request[1] = 1'b1;
		   		IFID_write_request[1] = 1'b1;
		   		IDEX_flush_request[1] = 1'b0;
		   		IFID_flush_request[1] = 1'b1;
			end
		else
			begin
		   		PCWrite_request[1] = 1'b1;
		   		IFID_write_request[1] = 1'b1;
		   		IDEX_flush_request[1] = 1'b0;
		   		IFID_flush_request[1] = 1'b0;
			end
	end

    // Branch
	always @(*) begin
		if(IDEX_PCSrc == 3'b100 && EX_need_branch == 1'b1) 
			begin
		   		PCWrite_request[2] = 1'b1;
		   		IFID_write_request[2] = 1'b1;
		   		IDEX_flush_request[2] = 1'b1;
		   		IFID_flush_request[2] = 1'b1;
			end
		else
			begin
		   		PCWrite_request[2] = 1'b1;
		   		IFID_write_request[2] = 1'b1;
		   		IDEX_flush_request[2] = 1'b0;
		   		IFID_flush_request[2] = 1'b0;
			end
	end
	
endmodule