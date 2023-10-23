
module ID_Stage_Reg(clk, rst, PCD, PCEX);

    input wire[0:0] clk, rst;
    input wire[0:31] PCD;
    output reg[0:31] PCEX;

    always@(posedge clk or posedge rst) begin

        PCEX = (rst) ? 32'b0 : PCD;

    end

endmodule