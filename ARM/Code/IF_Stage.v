module IF_Stage(clk, rst, PژF, instructionF, freeze);
    parameter N = 32;

    input clk, rst, freeze;

    output[N - 1:0] PCF, instructionF;
    
    wire[N - 1:0] PCRegIn, PCRegOut, PCPlus4F;

    Adder adder(   
        // adder module for updating PC(programming counter) to go to 
        // next instruction(4 bytes cause of 32 bit instructions)) 
        .a(32'd4), .b(PCRegOut), .out(PCPlus4F)
    );

    Mux2to1 muxPC(   
        // selecting PC register input which is either PC+4 or branch address (for branching commands)
        .a(PCPlus4F), .b(0), .s(0), .out(PCRegIn)
    ); //TODO: add select signal (branch taker) and other input (branch adder)

    Register PC(    
        .in(PCRegIn), .clk(clk), .en(1), .rst(rst), .out(PCRegOut)
    ); //FIXME: en=freeze

    assign PCF = PCPlus4F;

endmodule