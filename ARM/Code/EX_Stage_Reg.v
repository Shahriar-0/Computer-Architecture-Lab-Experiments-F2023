
module EXE_Stage_Reg(clk, rst, PCEX, PCMEM);
    parameter N = 32;
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCEX;
    output reg[N - 1:0] PCMEM;

    always@(posedge clk or posedge rst) begin

    PCMEM = (rst) ? 32'b0 : PCEX;

    end

endmodule