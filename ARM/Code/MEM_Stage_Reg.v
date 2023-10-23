
module MEM_Stage_Reg(clk, rst, PCMEM, PCWB);

    parameter N = 32;
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCMEM;
    output reg[N - 1:0] PCWB;

    always@(posedge clk or posedge rst) begin

        PCWB = (rst) ? 32'b0 : PCMEM;

    end

endmodule