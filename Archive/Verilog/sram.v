module Sram(
    input clk, rst,
    input SRAM_WE_N,
    input [17:0] SRAM_ADDR,
    inout [15:0] SRAM_DQ
);
    reg [15:0] memory [0:511];
    assign SRAM_DQ = (SRAM_WE_N == 1'b1) ? memory[SRAM_ADDR] : 16'dz;

    always @(posedge clk) begin
        if (SRAM_WE_N == 1'b0) begin
            memory[SRAM_ADDR] = SRAM_DQ;
        end
    end
endmodule
