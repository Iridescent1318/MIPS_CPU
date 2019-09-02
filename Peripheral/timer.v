module timer(
             clk_in,
             TL,
             TCON
);
    input clk_in;
    output reg [31:0] TL;

    reg [31:0] TH;
    output reg [2:0]  TCON;
    
    initial begin
        TH = 32'h00000004;
        TL = 32'h00000000;
        TCON = 3'b000;
    end
    
    always@(posedge clk_in) begin
        if(TCON[0]) begin
            if(TL == 32'hffffffff) begin
                TL <= TH;
                if(TCON[1]) TCON[2] <= 1'b1;
                else TCON[2] <= 1'b0;
            end
            else TL <= TL + 1;
        end
    end

endmodule