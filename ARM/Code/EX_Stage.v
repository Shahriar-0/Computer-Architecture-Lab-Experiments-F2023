
module EXE_Stage(clk, rst, WB_ENIn, MEM_R_ENIn, MEM_W_ENIn, EXE_CMDIn, BIn, SIn, PCIn, Val_RnIn, 
                    Val_RmIn, shiftOperandIn, IIn, Imm24In, DestIn, statusIn,
                    WB_ENOut, MEM_R_ENOut, MEM_W_ENOut, ALU_ResOut, Val_RmOut, DestOut, statusOut, branchAddressOut, SOut);
    
    input wire[0:0] clk, rst, WB_ENIn, MEM_R_ENIn, MEM_W_ENIn, BIn, SIn, IIn;
    input wire[3:0] EXE_CMDIn, DestIn, statusIn;
    input wire[11:0] shiftOperandIn;
    input wire[23:0] Imm24In;
    input wire[31:0] PCIn, Val_RnIn, Val_RmIn;

    output wire[0:0] WB_ENOut, MEM_R_ENOut, MEM_W_ENOut, SOut;
    output wire[3:0] DestOut, statusOut;
    output wire[31:0] PCOut, ALU_ResOut, Val_RmOut, branchAddressOut;


    wire[0:0] STypeSignal = MEM_R_ENIn | MEM_W_ENIn;
    wire[31:0] val2;
    Val2Generate val2Generator(
        .valRmIn(Val_RmIn), .shiftOperandIn(shiftOperandIn), 
        .IIn(IIn),          .STypeSignal(STypeSignal), 
        .valOut(val2)
    );


    ALU alu(
        .Val1In(Val_RnIn),     .Val2In(val2), 
        .EXE_CMDIn(EXE_CMDIn), .statusCarryIn(statusIn[1]), 
        .statusOut(statusOut), .ALU_ResOut(ALU_ResOut)
    );

    Adder branchAddressAdder(.a(PCIn), .b({{6{Imm24In[23]}}, Imm24In, 2'b00}), .out(branchAddressOut));

    assign WB_ENOut    = WB_ENIn;
    assign MEM_R_ENOut = MEM_R_ENIn;
    assign MEM_W_ENOut = MEM_W_ENIn;
    assign Val_RmOut   = Val_RmIn;
    assign DestOut     = DestIn;
    assign SOut        = SIn;

endmodule