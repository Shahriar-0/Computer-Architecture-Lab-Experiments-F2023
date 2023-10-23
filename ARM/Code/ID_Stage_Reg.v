
module ID_Stage_Reg(clk, rst, PCD, PCEX);
    parameter N = 32;

    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCD;
    output reg[N - 1:0] PCEX;

    always@(posedge clk or posedge rst) begin

        PCEX = (rst) ? 32'b0 : PCD;

    end

endmodule