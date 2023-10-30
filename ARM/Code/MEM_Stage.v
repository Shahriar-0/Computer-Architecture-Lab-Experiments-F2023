
module MEM_Stage(clk, rst, PCIn, PCOut);

    parameter N = 32;
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCIn;
    output wire[N - 1:0] PCOut;

    assign PCOut = PCIn;
endmodule