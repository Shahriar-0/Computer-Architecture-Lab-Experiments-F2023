module SRAM(clk, rst, SRAM_WE_NIn, SRAM_ADDRIn, SRAM_DQInOut);
    input clk, rst;
    input SRAM_WE_NIn;
    input [17:0] SRAM_ADDRIn;
    inout [15:0] SRAM_DQInOut;

    reg [15:0] memory [0:511];
    assign SRAM_DQInOut = (SRAM_WE_NIn == 1'b1) ? memory[SRAM_ADDRIn] : 16'dz;

    always @(posedge clk) begin
        if (SRAM_WE_NIn == 1'b0) 
            memory[SRAM_ADDRIn] = SRAM_DQInOut;
    end
endmodule
