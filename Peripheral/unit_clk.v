`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 15:18:54
// Design Name: 
// Module Name: unit_clk
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


module unit_clk(
    input sysclk,
    output u_clk
    );
    reg[27:0] state;
    reg[27:0] divide;
    reg u_clk_1;
assign u_clk = u_clk_1;
initial
begin
    u_clk_1 = 0;
    state = 28'b0000_0000_0000_0000_0000_0000_0000;
    divide = 28'b01011_1110_1011_1100_0010_0000_000; //ratio = 100,000,000, frequency = 1Hz
end
always@ (posedge sysclk)
begin
    if(state == 0) 
        u_clk_1 = ~u_clk_1;
    state = state + 21'b000_0000_0000_0000_0000_10;
    if(state == divide)
        state = 28'b0000_0000_0000_0000_0000_0000_0000;
end
endmodule