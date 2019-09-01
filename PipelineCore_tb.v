`timescale 1ns / 1ps

module PipelineCore_tb(
                       input sysclk,
                       input reset,
                       input start,
                       input iDisplaySwitch,
                       input iLeft,
                       input iRight,
                       input iClkSwitch,
                       input interrupt,
                       output [11:0] obcd, // 11:8 an3-an0 7:0 DP ... CB CA
                       output [7:0] display_order,
                       output [3:0] c_final_h
    );
    wire s_clk;
    wire u_clk;
    wire f_clk;
    wire cpu_clk;
    wire reset_d;
    wire iLeft_d;
    wire iRight_d;
//    wire interrupt;
    
//    assign interrupt = 0;
    
    debounce debounce0(sysclk, iLeft, iLeft_d);
    debounce debounce1(sysclk, iRight, iRight_d);
    debounce debounce2(sysclk, reset, reset_d);
    
    scan_clk scan_clk0(sysclk, s_clk);
    unit_clk unit_clk0(sysclk, u_clk);
    c_clk c_clk0(sysclk, f_clk);
    assign cpu_clk = (iClkSwitch)? f_clk: u_clk;
    
    reg  [31:0] c_start, c_stop;
    wire [31:0] count;
    wire c_s, c_t;
    
    reg  [6:0] address;
    wire [31:0] data;
    wire [31:0] display_data;
    
    initial begin
        c_start = 32'h0;
        c_stop = 32'h0;
        address = 7'h0;
    end

    
    PipelineCore PipelineCore0(.clk(cpu_clk & start), .reset(reset_d), .iInterrupt(interrupt),
                               .iAddress(address), .oData(data), 
                               .oCountStart(c_s), .oCountStop(c_t));
                               
    sysclk_counter sysclk_counter0(.sysclk(cpu_clk & start), .reset(reset_d), 
                                   .interrupt(interrupt), .count(count));
    
    always@(posedge c_s) begin
        c_start <= count;
    end
    
    always@(posedge c_t) begin
        c_stop <= count;
    end
    
    wire [31:0] c_final;
    assign c_final = c_stop - c_start;
    assign c_final_h = c_final[19:16];
    
    always@(posedge iLeft_d or posedge iRight_d) begin
        if(iLeft_d) address <= 7'h0;
        else if(iRight_d) address <= (address == 7'h63)? 7'h0: address + 7'b0000001;
    end
    
    assign display_data = (iDisplaySwitch)? data[15:0]: c_final[15:0];
    assign display_order = (iDisplaySwitch)? {1'b0, address}: 8'b0;
    
    BCD7 BCD7_0(.scan_clk(s_clk), .idata(display_data), .iInterrupt(interrupt), .obcd(obcd));
    
endmodule
