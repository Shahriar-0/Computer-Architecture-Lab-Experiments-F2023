
module WB_Stage(clk, rst, ALU_ResIn, DataMemoryIn, MEM_R_ENIn, WB_DestIn, WB_DestOut, WB_ENIn, WB_ENOut, WB_ValueOut, WB_ValueOut);

    parameter N = 32;
    input wire[0:0] clk, rst;

    Mux2to1 mux(.a(ALU_ResIn), .b(DataMemoryIn), .s(MEM_R_ENIn), .out(WB_ValueOut));

    assign WB_ENOut = WB_ENIn;
    assign WB_DestOut = WB_DestIn;


endmodule