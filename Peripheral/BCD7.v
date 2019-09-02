module BCD7(
            scan_clk,
            idata,
            iInterrupt,
            obcd
);
    input scan_clk;
    input [15:0] idata;
    input iInterrupt;
    output reg [11:0] obcd; // 11:8 an3-an0 7:0 DP ... CB CA
    
    reg [4:0] display; 
    
    initial begin
        obcd = 12'b101111111111;
    end
    
    always@(posedge scan_clk) begin
        case(obcd[11:8])
        4'b1101: display = iInterrupt? 5'b10000: {1'b0, idata[15:12]};
        4'b1110: display = iInterrupt? 5'b10001: {1'b0, idata[11:8]}; 
        4'b0111: display = iInterrupt? 5'b10010: {1'b0, idata[7:4]};
        4'b1011: display = iInterrupt? 5'b10011: {1'b0, idata[3:0]};
        endcase
    end
    
    always@(posedge scan_clk) begin
        obcd[11:8] = (obcd[11:8] << 1) +1;
        if(obcd[11:8] == 4'b1111) obcd[11:8] = obcd[11:8] - 1;
    end
    
    always@(posedge scan_clk) begin
             obcd[7:0] = (display==5'h0)?8'b11000000:
             (display==5'h1)?8'b11111001:
             (display==5'h2)?8'b10100100:
             (display==5'h3)?8'b10110000:
             (display==5'h4)?8'b10011001:
             (display==5'h5)?8'b10010010:
             (display==5'h6)?8'b10000010:
             (display==5'h7)?8'b11111000:
             (display==5'h8)?8'b10000000:
             (display==5'h9)?8'b10010000:
             (display==5'ha)?8'b10001000:
             (display==5'hb)?8'b10000011:
             (display==5'hc)?8'b11000110:
             (display==5'hd)?8'b10100001:
             (display==5'he)?8'b10000110:
             (display==5'hf)?8'b10001110:
             (display==5'b10001)?8'b11111011:
             (display==5'b10010)?8'b10101011:
             (display==5'b10011)?8'b10000111:
             8'b11111111;
    end

endmodule