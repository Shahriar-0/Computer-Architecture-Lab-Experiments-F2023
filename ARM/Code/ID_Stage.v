
module ID_Stage(clk, rst, PCD, PCEX);

    input wire[0:0] clk, rst;
    inpit wire[0:31] PCD;
    output wire[0:31] PCEX;

    assign PCEX = PCD;
endmodule