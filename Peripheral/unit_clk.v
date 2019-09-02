`timescale 1ns / 1ps

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
    //divide = 28'b1011_1110_1011_1100_0010_0000_0000; //ratio = 200,000,000, frequency = 0.5Hz ?
    divide = 28'b0000010_1111_1010_1111_0000_1000_0; // ratio = 6,250,000, frequency = 16Hz
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