
module EXE_Stage(clk, rst, PCIn, PCOut, Val1In, Val2In, 
                 statuCarryIn, SIn, EXE_CMDIn, ALU_ResOut, StatusRegOut);
    parameter N = 32;
    
    input wire[0:0] clk, rst;
    input wire[N - 1:0] PCIn, Val1In, Val2In, EXE_CMDIn;

    output wire[N - 1:0] PCOut, ALU_ResOut;

    wire [N - 1: 0]
        statusRegIn;


    ALU #(32) alu(
        .Val1In(Val1In),
        .Val2In(Val2In),
        .statuCarryIn(statuCarryIn),
        .EXE_CMDIn(EXE_CMDIn),
        .ALU_ResOut(ALU_ResOut),
        .statusIn(statusRegIn)
    );

    RegisterNegEdge #(4) statusReg(
        .clk(clk),
        .rst(rst),
        .en(SIn),
        .in(statusIn),
        .out(StatusRegOut)
    );

    assign PCOut = PCIn;
endmodule