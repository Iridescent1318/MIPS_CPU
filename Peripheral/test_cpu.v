
module test_cpu(
    input clk,
    input [1:0] sw,
    input reset,
    output [3:0] an,
    output [7:0] caths,
    output [7:0] PC_8b
);
	
	wire reset;
	wire [1:0] sw;
	reg [15:0] cur_display;
	wire [7:0] caths;
	//assign caths = caths1;
	
	wire u_clk;
	unit_clk unit_clk1(clk, u_clk);
	wire s_clk;
	scan_clk scan_clk1(clk, s_clk);
	
	CPU cpu1(reset, u_clk);
	
	wire [7:0] PC_8b;
	wire [15:0] a0;
	wire [15:0] v0;
	wire [15:0] sp;
	wire [15:0] ra;
	wire [3:0] an;
	
	assign PC_8b = cpu1.PC[7:0];
	assign a0 = cpu1.register_file1.RF_data[4][15:0];
	assign v0 = cpu1.register_file1.RF_data[2][15:0];
	assign sp = cpu1.register_file1.RF_data[29][15:0];
	assign ra = cpu1.register_file1.RF_data[31][15:0];
	
	always@(posedge clk) begin
	    case(sw)
	    2'b00: cur_display = a0;
	    2'b01: cur_display = v0;
	    2'b10: cur_display = sp;
	    2'b11: cur_display = ra;
	    endcase
	end
	
	bcd_display bcd_display1(s_clk, cur_display, caths);
	assign an[3:0] = bcd_display1.AN[3:0];
	//always #50 clk = ~clk;		
		
endmodule
