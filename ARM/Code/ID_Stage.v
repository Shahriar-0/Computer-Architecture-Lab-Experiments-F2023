
module ID_Stage(clk, rst, instructionIn, MEM_W_ENIn, WB_ENIn, WB_DestIn, WB_ValueIn, HazardIn, PCIn, 
                PCOut, val_RnOut, val_RmOut, Two_srcOut, RnOut, statusIn);

    parameter N = 32;
    input wire[0:0] clk, rst, MEM_W_ENIn, WB_ENIn;
    input wire[3:0] WB_DestIn;
    input wire[N - 1:0] PCIn, instrIn, WB_ValueIn;
    output wire[N - 1:0] PCOut, val_RnOut, val_RmOut;
    output wire[0:0] Two_srcOut, statusIn;

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

    wire[3:0] rm;
    assign rm = instructionIn[3:0];

    wire[3:0] cond;
    assign cond = instructionIn[31:28];

    wire[0:0] i;
    assign i = instructionIn[25];

    wire[3:0] readReg2;
    assign readReg2 = (~MEM_W_ENIn) ? rm : rd;

    RegisterFile registerFile(.clk(clk), .regWrite(WB_ENIn),
                    .readRegister1(rn), .readRegister2(readReg2),
                    .writeRegister(WB_DestIn), .writeData(WB_ValueIn),
                    .readData1(val_RnOut), .readData2(val_RmOut));

    
    assign Two_srcOut = ~i | MEM_W_ENIn;

    assign RnOut = rn;

    wire[0:0] conditionCheckOut;
    ConditionCheck conditionCheck(.condIn(cond), .condOut(conditionCheckOut), .statusIn(statusIn));

    wire[0:0] conditionCheckOutOrHazard;
    assign conditionCheckOutOrHazard = conditionCheckOut | HazardIn;

    wire[8:0] controlUnitOut
    ControlUnit controlUnit(.opCodeIn(opCode), SIn(s), .modeIn(mode), 
                            EXE_CMDOut, SOut, BOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut)

    assign PCOut = PCIn;
endmodule