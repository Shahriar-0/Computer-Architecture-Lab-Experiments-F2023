module IF_Stage(clk, rst, IF_IFR_PC, IF_IFR_Instruction, freeze, MEM_MEMR_branchAdder, branchTakenMem);
    parameter N = 32;

    input clk, rst, freeze, branchTakenMem;
    
    input[N-1:0] MEM_MEMR_branchAdder;

    output[N - 1:0] IF_IFR_PC, IF_IFR_Instruction;
    
    wire[N - 1:0] PCRegIn, PCRegOut, PCPlus4F;

    // assign MEM_MEMR_branchAdder = branchTakenMem = freeze = 0;

    Adder adder(   
        // adder module for updating PC(programming counter) to go to 
        // next instruction(4 bytes cause of 32 bit instructions)) 
        .a(32'd4), .b(PCRegOut), .out(PCPlus4F)
    );

    Mux2to1 muxPC(   
        // selecting PC register input which is either PC+4 or branch address (for branching commands)
        .a(PCPlus4F), .b(MEM_MEMR_branchAdder), .s(branchTakenMem), .out(PCRegIn)
    ); 

    Register PC(    
        .in(PCRegIn), .clk(clk), .en(~freeze), .rst(rst), .out(PCRegOut)
    ); 

    assign IF_IFR_PC = PCPlus4F;

endmodule