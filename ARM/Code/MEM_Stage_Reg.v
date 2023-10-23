
module MEM_Stage_Reg(clk, rst, PCMEM, PCWB);

    input wire[0:0] clk, rst;
    inpit wire[0:31] PCMEM;
    output reg[0:31] PCWB;

    always@(posedge clk or posedge rst) begin

    PCWB = (rst) ? 32'b0 : PCMEM;

    end

endmodule