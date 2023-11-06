
module EXE_Stage(clk, rst, WB_NIn, MEM_R_ENIn, MEM_W_ENIn, EXE_CMDIn, BIn, SIn, PCIn, Val_RnI, Val_RmIn, );
    parameter N = 32;
    
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCIn/*, Val1In, Val2In, EXE_CMDIn*/;

    output wire[N - 1:0] PCOut/*, ALU_ResOut*/;

    // wire [N - 1: 0]
    //     statusRegIn;


    // ALU #(32) alu(
    //     .Val1In(Val1In),
    //     .Val2In(Val2In),
    //     .statuCarryIn(statuCarryIn),
    //     .EXE_CMDIn(EXE_CMDIn),
    //     .ALU_ResOut(ALU_ResOut),
    //     .statusIn(statusRegIn)
    // );

    // RegisterNegEdge #(4) statusReg(
    //     .clk(clk),
    //     .rst(rst),
    //     .en(SIn),
    //     .in(statusIn),
    //     .out(StatusRegOut)
    // );

    assign PCOut = PCIn;
endmodule