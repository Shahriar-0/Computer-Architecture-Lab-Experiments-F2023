
module EXE_Stage(clk, rst, PCEX, PCMEM);
    parameter N = 32;
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCEX;
    output wire[N - 1:0] PCMEM;

    assign PCMEM = PCEX;
endmodule