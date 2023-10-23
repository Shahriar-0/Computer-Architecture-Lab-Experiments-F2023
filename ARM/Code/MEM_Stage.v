
module MEM_Stage(clk, rst, PCMEM, PCWB);

    input wire[0:0] clk, rst;
    inpit wire[0:31] PCMEM;
    output wire[0:31] PCWB;

    assign PCWB = PCMEM;
endmodule