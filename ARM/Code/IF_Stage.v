module IF_Stage(clk, rst, freeze, branchTakenIn, PCOut, instructionOut, branchAddressIn);
    parameter N = 32;

    input wire[0:0] clk, rst, freeze, branchTakenIn;
    input wire[N-1:0] branchAddressIn;
    output wire [N - 1:0] PCOut, instructionOut;
    
    wire[N - 1:0] PCRegIn, PCRegOut, PCPlus4;

    Adder adder(   
        .a(32'd4), .b(PCRegOut), .out(PCPlus4)
    );

    Mux2to1 #(32) muxPC(   
        .a(PCPlus4), .b(branchAddressIn), .s(branchTakenIn), .out(PCRegIn)
    ); 

    RegisterPosEdge PC(    
        .in(PCRegIn), .clk(clk), .en(~freeze), .rst(rst), .out(PCRegOut)
    ); 

    Instruction_Memory instructionMemory(
        .PC(PCRegOut), .instruction(instructionOut)
    );

    assign PCOut = PCPlus4;

endmodule