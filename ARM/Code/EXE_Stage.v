
module EXE_Stage(clk, rst, PCEX, PCMEM);

    input wire[0:0] clk, rst;
    input wire[0:31] PCEX;
    output wire[0:31] PCMEM;

    assign PCMEM = PCEX;
endmodule