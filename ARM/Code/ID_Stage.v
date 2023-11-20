
module ID_Stage(clk, rst, instructionIn, WB_ENIn, WB_DestIn, WB_ValueIn, 
                HazardIn, PCIn, statusIn, PCOut, Val_RnOut, Val_RmOut, 
                Two_srcOut, SOut, BOut, EXE_CMDOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut,
                DestOut, IOut, regFileInp2Out, shiftOperandOut, Imm24Out);

    parameter N = 32;
    
    input wire[0:0] clk, rst, WB_ENIn, HazardIn;
    input wire[3:0] WB_DestIn, statusIn;
    input wire[N - 1:0] PCIn, instructionIn, WB_ValueIn;
    output wire[N - 1:0] PCOut, Val_RnOut, Val_RmOut;
    output wire[0:0] Two_srcOut, SOut, BOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut, IOut;
    output wire[3:0] EXE_CMDOut, DestOut, regFileInp2Out;
    output wire[11:0] shiftOperandOut;
    output wire[23:0] Imm24Out;

    wire[1:0] mode;
    assign mode = instructionIn[27:26];

    wire[3:0] opCode;
    assign opCode = instructionIn[24:21];

    wire[0:0] s;
    assign s = instructionIn[20];

    wire[3:0] rn;
    assign rn = instructionIn[19:16];

    wire[3:0] rd;
    assign rd = instructionIn[15:12];
    assign DestOut = rd;

    wire[3:0] rm;
    assign rm = instructionIn[3:0];

    wire[3:0] cond;
    assign cond = instructionIn[31:28];

    assign shiftOperandOut = instructionIn[11:0];
    assign Imm24Out = instructionIn[23:0];

    wire[0:0] i;
    assign i = instructionIn[25];
    assign IOut = i;


    wire[8:0] controlUnitOut;
    ControlUnit controlUnit(
        // Control Unit module for decode instructions and set control signals
        .opCodeIn(opCode), .SIn(s), .modeIn(mode), 
        .EXE_CMDOut(controlUnitOut[3:0]), .SOut(controlUnitOut[4]), .BOut(controlUnitOut[5]), 
        .MEM_W_ENOut(controlUnitOut[6]), .MEM_R_ENOut(controlUnitOut[7]), .WB_ENOut(controlUnitOut[8])
    );

    wire[0:0] conditionCheckOut;
    ConditionCheck conditionCheck(
        // This module check the condition that specified in the instruction
        // if the condition is false, the instruction converts to NOP    
        .condIn(cond), .condOut(conditionCheckOut), .statusIn(statusIn)
    );

    wire[0:0] controlSignalsSelector;
    assign controlSignalsSelector = (~conditionCheckOut) | HazardIn;

    wire[8:0] signals;
    Mux2to1 #(9) controlSignalsMux(
        // select between control signals that are produced in Control Unit module and 9'b0(do nothing)
        .a(controlUnitOut), .b(9'b0), .s(controlSignalsSelector), .out(signals)
    );

    assign EXE_CMDOut = signals[3:0];
    assign SOut = signals[4];
    assign BOut = signals[5];
    assign MEM_W_ENOut = signals[6];
    assign MEM_R_ENOut = signals[7];
    assign WB_ENOut = signals[8];


    wire[3:0] regInp2;
    Mux2to1 #(4) regInp2Mux(
        // select rd as a source just when the instruction is STR
        .a(rm), .b(rd), .s(signals[6]), .out(regInp2)        
    );
    assign regFileInp2Out = regInp2;

    RegisterFile registerFile(
        // Register file :)
        .clk(clk), .rst(rst), .regWrite(WB_ENIn),
        .readRegister1(rn), .readRegister2(regInp2),
        .writeRegister(WB_DestIn), .writeData(WB_ValueIn),
        .readData1(Val_RnOut), .readData2(Val_RmOut)
    );

    assign Two_srcOut = ~i | signals[6];

    assign PCOut = PCIn;

endmodule