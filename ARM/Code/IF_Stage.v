module IF_Stage(clk, rst, PCF, instructionF, freezeF, branchAdderF, branchTakenF);
    parameter N = 32;

    input clk, rst, freeze, branchAdderF, branchTakenF;

    output[N - 1:0] PCF, instructionF;
    
    wire[N - 1:0] PCRegIn, PCRegOut, PCPlus4F;

    assign branchAdderF = branchTakenF = freezeF = 0;

    Adder adder(   
        // adder module for updating PC(programming counter) to go to 
        // next instruction(4 bytes cause of 32 bit instructions)) 
        .a(32'd4), .b(PCRegOut), .out(PCPlus4F)
    );

    Mux2to1 muxPC(   
        // selecting PC register input which is either PC+4 or branch address (for branching commands)
        .a(PCPlus4F), .b(branchAdderF), .s(branchTakenF), .out(PCRegIn)
    ); 

    Register PC(    
        .in(PCRegIn), .clk(clk), .en(freezeF), .rst(rst), .out(PCRegOut)
    ); 

    assign PCF = PCPlus4F;

endmodule