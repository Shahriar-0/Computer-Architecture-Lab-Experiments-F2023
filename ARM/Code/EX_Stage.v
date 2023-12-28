
module EXE_Stage(clk, rst, MEM_R_ENIn, MEM_W_ENIn, EXE_CMDIn, 
                 PCIn, Val_RnIn, Val_RmIn, shiftOperandIn, 
                 IIn, Imm24In, statusIn, 
                 ALU_ResOut, statusOut, 
                 branchAddressOut, WB_ValueIn, ALU_ResIn, selSrc1In, selSrc2In);
    
    input wire[0:0] clk, rst, MEM_R_ENIn, MEM_W_ENIn, IIn;
    input wire[1:0] selSrc1In, selSrc2In;
    input wire[3:0] EXE_CMDIn, statusIn;
    input wire[11:0] shiftOperandIn;
    input wire[23:0] Imm24In;
    input wire[31:0] PCIn, Val_RnIn, Val_RmIn, WB_ValueIn, ALU_ResIn;

    output wire[3:0] statusOut;
    output wire[31:0] ALU_ResOut, branchAddressOut;


    wire[0:0] STypeSignal = MEM_R_ENIn | MEM_W_ENIn;
    wire[31:0] val1, val2, val2GeneratorIn;

    Mux4to1 mux1(
        .a(Val_RnIn), .b(ALU_ResIn), .c(WB_ValueIn), 
        .d(32'bz), .s(selSrc1In), .out(val1)
    );

    Mux4to1 mux2(
        .a(Val_RmIn), .b(ALU_ResIn), .c(WB_ValueIn), 
        .d(32'bz), .s(selSrc2In), .out(val2GeneratorIn)
    );

    Val2Generate val2Generator(
        .valRmIn(val2GeneratorIn), .shiftOperandIn(shiftOperandIn), 
        .IIn(IIn),                 .STypeSignal(STypeSignal), 
        .valOut(val2)
    );

    ALU alu(
        .Val1In(val1),         .Val2In(val2), 
        .EXE_CMDIn(EXE_CMDIn), .statusCarryIn(statusIn[1]), 
        .statusOut(statusOut), .ALU_ResOut(ALU_ResOut)
    );

    Adder branchAddressAdder(
        .a(PCIn), .b({{6{Imm24In[23]}}, Imm24In, 2'b00}), .out(branchAddressOut)
    );

endmodule
