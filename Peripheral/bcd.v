`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 14:53:51
// Design Name: 
// Module Name: bcd
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

module bcd(
	din,
	dout
);
input 	[3:0]   din;
output 	[7:0] 	dout;
integer din1;
assign din = din1;

wire [7:0] dout;

assign	dout=(din1==4'h0)?8'b00000011:
             (din1==4'h1)?8'b10011111:
             (din1==4'h2)?8'b00100101:
             (din1==4'h3)?8'b00001101:
             (din1==4'h4)?8'b10011001:
             (din1==4'h5)?8'b01001001:
             (din1==4'h6)?8'b01000001:
             (din1==4'h7)?8'b00011111:
             (din1==4'h8)?8'b00000001:
             (din1==4'h9)?8'b00001001:
             (din1==4'ha)?8'b00010011:
             (din1==4'hb)?8'b11000001:
             (din1==4'hc)?8'b01100011:
             (din1==4'hd)?8'b10000101:
             (din1==4'he)?8'b01100001:
             (din1==4'hf)?8'b01110001:
             8'b11111111;
endmodule

