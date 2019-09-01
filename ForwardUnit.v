`timescale 1ns / 1ps

module ForwardUnit(
                   EXMEM_RegWrite,
                   EXMEM_RegWriteAddr,
                   IDEX_Rt,
                   IDEX_Rs,
                   ID_PCSrc,
                   IFID_Rs,
                   IDEX_RegWriteAddr,
                   IDEX_RegWrite,
                   MEMWB_RegWrite,
                   MEMWB_RegWriteAddr,
                   ForwardA,
                   ForwardB,
                   ForwardJ
    );
    input EXMEM_RegWrite;
    input [4:0] EXMEM_RegWriteAddr;
    input [4:0] IDEX_Rt;
    input [4:0] IDEX_Rs;
    input [2:0] ID_PCSrc;
    input [4:0] IFID_Rs;
    input [4:0] IDEX_RegWriteAddr;
    input IDEX_RegWrite;
    input MEMWB_RegWrite;
    input [4:0] MEMWB_RegWriteAddr;
    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;
    output reg [1:0] ForwardJ;

    initial begin
    	ForwardA = 2'b00;
    	ForwardB = 2'b00;
    	ForwardJ = 2'b00;
    end

    always @(*) begin
        if(EXMEM_RegWrite == 1'b1 && // Register writing enabled
           EXMEM_RegWriteAddr != 5'b0 && // Not writing $0
           EXMEM_RegWriteAddr == IDEX_Rs // Will use the same register immediately in EX
           )
                ForwardA = 2'b10;
        else if(MEMWB_RegWrite == 1'b1 && // Register writing enabled
                MEMWB_RegWriteAddr != 5'b0 && // Not writing $0
                MEMWB_RegWriteAddr == IDEX_Rs // Will use the same register immediately in EX
                )
                ForwardA = 2'b01;
        else
                ForwardA = 2'b00;

        if(EXMEM_RegWrite == 1'b1 && // Register writing enabled
           EXMEM_RegWriteAddr != 5'b0 && // Not writing $0
           EXMEM_RegWriteAddr == IDEX_Rt // Will use the same register immediately in EX
           )
                ForwardB = 2'b10;
        else if(MEMWB_RegWrite == 1'b1 && // Register writing enabled
                MEMWB_RegWriteAddr != 5'b0 && // Not writing $0
                MEMWB_RegWriteAddr == IDEX_Rt // Will use the same register immediately in EX
                )
                ForwardB = 2'b01;
        else
                ForwardB = 2'b00;

        if(ID_PCSrc == 3'b010 && // jr, jalr
           IFID_Rs == IDEX_RegWriteAddr && // Will use the same register immediately in ID
           IDEX_RegWrite && // Register writing enabled
           IDEX_RegWriteAddr != 0 //Not writing $0
          )
                ForwardJ = 2'b01;

        else if(ID_PCSrc == 3'b010 &&
                IFID_Rs != IDEX_RegWriteAddr &&
                IFID_Rs == EXMEM_RegWriteAddr &&
                EXMEM_RegWrite &&
                EXMEM_RegWriteAddr != 0
                )
                ForwardJ = 2'b10;
                else if(ID_PCSrc == 3'b010 &&
                        IFID_Rs != IDEX_RegWriteAddr &&
                        IFID_Rs != EXMEM_RegWriteAddr &&
                        IFID_Rs == MEMWB_RegWriteAddr &&
                        MEMWB_RegWrite &&
                        MEMWB_RegWriteAddr != 0
                        )
                        ForwardJ = 2'b11;
                    else
                        ForwardJ = 2'b00;
    end   
    
endmodule
