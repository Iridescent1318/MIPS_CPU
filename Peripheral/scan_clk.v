`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 15:50:51
// Design Name: 
// Module Name: scan_clk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module scan_clk(
    input sysclk,
    output s_clk
    );
    reg[27:0] state;
    reg[27:0] divide;
    reg s_clk_1;
assign s_clk = s_clk_1;
initial
begin
    s_clk_1 = 0;
    state = 28'b0000_0000_0000_0000_0000_0000_0000;
    divide = 28'b0000_0000_0001_1000_0110_1010_0000; //ratio = 100,000, frequency = 1,000Hz
end
always@ (posedge sysclk)
begin
    if(state == 0) 
        s_clk_1 = ~s_clk_1;
    state = state + 21'b000_0000_0000_0000_0000_10;
    if(state == divide)
        state = 28'b0000_0000_0000_0000_0000_0000_0000;
end
endmodule
