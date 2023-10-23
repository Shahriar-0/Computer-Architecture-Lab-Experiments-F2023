
module WB_Stage(clk, rst, PCWB, PCF);

    parameter N = 32;
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCWB;
    output wire[N - 1:0] PCF;

    assign PCF = PCWB;
endmodule