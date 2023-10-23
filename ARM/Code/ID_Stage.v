
module ID_Stage(clk, rst, PCD, PCEX);

    parameter N = 32;
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCD;
    output wire[N - 1:0] PCEX;

    assign PCEX = PCD;
endmodule