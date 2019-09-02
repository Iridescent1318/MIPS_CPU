module sysclk_counter(
                      input sysclk,
                      input reset,
                      input interrupt,
                      output reg [31:0] count
);

    initial begin
        count = 32'h00000000;
    end

    always@(posedge sysclk or posedge reset) begin
        if(reset) count <= 32'h00000000;
        else if(~interrupt) 
            count <= (count == 32'hffffffff)? 32'h0: count + 1'b1;
    end
    
endmodule