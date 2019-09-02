`timescale 1ns / 1ps


module c_clk(
    input sysclk,
    output reg cpu_clk
    );
    
    initial begin
        cpu_clk = 0;
    end
    
    always@(posedge sysclk) begin
        cpu_clk <= ~cpu_clk;
    end 
    
endmodule
