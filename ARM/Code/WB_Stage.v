
module WB_Stage(clk, rst, ALU_ResIn, DataMemoryIn, 
                MEM_R_ENIn, WB_DestIn, WB_DestOut,
                WB_ENIn, WB_ENOut, WB_ValueOut);

    parameter N = 32;
    input wire[0:0] clk, rst;

    input wire[N - 1: 0] ALU_ResIn, DataMemoryIn;
    input wire[3:0] WB_DestIn;
    input wire[0:0] WB_ENIn, MEM_R_ENIn;

    output wire[N - 1: 0] WB_ValueOut;
    output wire[3:0] WB_DestOut;
    output wire[0:0] WB_ENOut;


    Mux2to1 mux(
        .a(ALU_ResIn), .b(DataMemoryIn), .s(MEM_R_ENIn), .out(WB_ValueOut)
    );

    assign WB_ENOut = WB_ENIn;
    assign WB_DestOut = WB_DestIn;

endmodule