
module EXE_Stage_Reg(clk, rst, PCEX, PCMEM);

    input wire[0:0] clk, rst;
    input wire[0:31] PCEX;
    output reg[0:31] PCMEM;

    always@(posedge clk or posedge rst) begin

    PCMEM = (rst) ? 32'b0 : PCEX;

    end

endmodule