module IF_Stage(clk, rst, freeze, branchTakenIn, PCOut, instructionOut, branchAddressIn);
    parameter N = 32;

    input wire[0:0] clk, rst, freeze, branchTakenIn;
    input wire[N - 1:0] branchAddressIn;
    output wire [N - 1:0] PCOut, instructionOut;
    
    wire[N - 1:0] PCRegIn, PCRegOut, PCPlus4;

    Adder adder(  // For updating PC value to PC + 4 cause instructions are 4 bytes (32 bits) long 
        .a(32'd4), .b(PCRegOut), .out(PCPlus4)
    );

    Mux2to1 #(32) muxPC(  // For updating PC value to branch address if branch is taken
        .a(PCPlus4), .b(branchAddressIn), .s(branchTakenIn), .out(PCRegIn)
    ); 

    RegisterPosEdge PC(  // For storing PC value
        .in(PCRegIn), .clk(clk), .en(~freeze), .rst(rst), .out(PCRegOut)
    ); 

    Instruction_Memory instructionMemory(  // For storing instructions 
        .PC(PCRegOut), .instruction(instructionOut)
    );

    assign PCOut = PCPlus4;

endmodule