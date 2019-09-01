module IF(
        clk,
        reset,
        iPC_next,
        iPCWrite,
        iInterrupt,
        oPC_plus_4,
        oInstruction,
        oInterrupt
);
    input clk;
    input reset;
    input [31:0] iPC_next;
    input iPCWrite;
    input iInterrupt;
    output [31:0] oPC_plus_4;
    output [31:0] oInstruction;
    output oInterrupt;

    reg [31:0] PC;
    wire [31:0] PC_next;

    initial begin
    	PC = 32'h00000000;
    end

	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h80000000;
		else
		begin
		    if(iPCWrite) begin
			    PC <= iPC_next;
			end
	end
	
	wire [31:0] oPC_plus_4;
	assign oPC_plus_4 = {PC[31], PC[30:0] + 31'd4};
    
    assign oInterrupt = ~PC[31] & iInterrupt;

    InstructionMemory InstructionMemory0(.Address(PC), .Instruction(oInstruction));

endmodule