
module EXE_Stage_Reg(clk, rst, pc_in, pc);

    input wire[0:0] clk, rst;
    inpit wire[0:31] pc_in;
    output reg[0:31] pc;

    always@(posedge clk, posedge rst) begin

    pc = (rst) ? 32'b0 : pc_in;

    end

endmodule