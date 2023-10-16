module InstructionFetch(PCPlus4, instruction, clk, rst);
    parameter N = 32;
    input clk, rst;

    output[N - 1:0] PCPlus4, instruction;
    
    wire[N - 1:0] oldPC, newPC;

    Adder adder(
        .a(32'd4), .b(oldPC), .w(PCPlus4)
    );

    Mux2to1 muxPC(
        .a(PCPlus4), .b(0), .s(0), .out(newPC)
    ); //FIXME

    Register PC(
        .in(newPC), .clk(clk), .en(1), .rst(rst), .out(oldPC)
    ); //FIXME freeze, check rstoldPC
endmodule