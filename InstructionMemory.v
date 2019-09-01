module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		case (Address[9:2])
			8'd0:  Instruction <= 32'h08100003;
			8'd1:  Instruction <= 32'h0810001b;
			8'd2:  Instruction <= 32'h08100020;
			8'd3:  Instruction <= 32'h20040000;
			8'd4:  Instruction <= 32'h20050064;
			8'd5:  Instruction <= 32'h10850014;
			8'd6:  Instruction <= 32'h00043020;
			8'd7:  Instruction <= 32'h10c5000f;
			8'd8:  Instruction <= 32'h00044880;
			8'd9:  Instruction <= 32'h01284820;
			8'd10: Instruction <= 32'h8d2b0000;
			8'd11: Instruction <= 32'h00065080;
			8'd12: Instruction <= 32'h01485020;
			8'd13: Instruction <= 32'h8d4c0000;
			8'd14: Instruction <= 32'h016c6822;
			8'd15: Instruction <= 32'h19a00005;
			8'd16: Instruction <= 32'h000b7020;
			8'd17: Instruction <= 32'h000c5820;
			8'd18: Instruction <= 32'h000e6020;
			8'd19: Instruction <= 32'had2b0000;
			8'd20: Instruction <= 32'had4c0000;
			8'd21: Instruction <= 32'h20c60001;
			8'd22: Instruction <= 32'h08100007;
			8'd23: Instruction <= 32'h20840001;
			8'd24: Instruction <= 32'h08100005;
			8'd25: Instruction <= 32'h00000000;
			8'd26: Instruction <= 32'h1000ffff;
			8'd27: Instruction <= 32'h20180000;
			8'd28: Instruction <= 32'h2019001e;
			8'd29: Instruction <= 32'h23180001;
			8'd30: Instruction <= 32'h1719fffe;
			8'd31: Instruction <= 32'h03400008;

// Bug: jal cannot save to register.

			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
