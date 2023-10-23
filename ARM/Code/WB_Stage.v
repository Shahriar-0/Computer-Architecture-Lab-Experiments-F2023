
module WB_Stage(clk, rst, PCWB, PCF);

    input wire[0:0] clk, rst;
    inpit wire[0:31] PCWB;
    output wire[0:31] PCF;

    assign PCF = PCWB;
endmodule