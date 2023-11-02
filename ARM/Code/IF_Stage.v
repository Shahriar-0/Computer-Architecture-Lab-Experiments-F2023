module IF_Stage(clk, rst, freeze, branchTakenIn, PCOut, instructionOut, branchAddressIn);
    parameter N = 32;

    input wire[0:0] clk, rst, freeze, branchTakenIn;
    input wire[N-1:0] branchAddressIn;
    output wire [N - 1:0] PCOut, instructionOut;
    
    wire[N - 1:0] PCRegIn, PCRegOut, PCPlus4;

    Adder adder(   
        // adder module for updating PC(programming counter) to go to 
        // next instruction(4 bytes cause of 32 bit instructions)) 
        .a(32'd4), .b(PCRegOut), .out(PCPlus4)
    );

    Mux2to1 #(32) muxPC(   
        // selecting PC register input which is either PC+4 or branch address (for branching commands)
        .a(PCPlus4), .b(branchAddressIn), .s(branchTakenIn), .out(PCRegIn)
    ); 

    Register PC(    
        // PC register that specifies what instruction to read
        .in(PCRegIn), .clk(clk), .en(~freeze), .rst(rst), .out(PCRegOut)
    ); 

    Instruction_Memory instructionMemory(
        // Intsructions are stored in this memory
        .PC(PCRegOut), .instruction(instructionOut)
    );

    assign PCOut = PCPlus4;

endmodule