
module MEM_Stage(clk, rst, PCMEM, PCWB);

    parameter N = 32;
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCMEM;
    output wire[N - 1:0] PCWB;

    assign PCWB = PCMEM;
endmodule