
module ID_Stage_Reg(clk, rst, PCIn, PCOut);
    parameter N = 32;

    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCIn;
    output reg[N - 1:0] PCOut;

    always@(posedge clk or posedge rst) begin

        PCOut = (rst) ? 32'b0 : PCIn;

    end

endmodule