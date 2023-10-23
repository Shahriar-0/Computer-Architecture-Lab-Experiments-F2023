
module EXE_Stage(clk, rst, pc_in, pc);

    input wire[0:0] clk, rst;
    inpit wire[0:31] pc_in;
    output wire[0:31] pc;

    assign pc = pc_in;
endmodule