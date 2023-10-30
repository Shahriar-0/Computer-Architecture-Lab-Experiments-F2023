
module ID_Stage(clk, rst, instructionIn, MEM_W_ENIn, WB_ENIn, WB_DestIn, WB_ValueIn, HazardIn, PCIn, statusIn,
                PCOut, val_RnOut, val_RmOut, Two_srcOut, SOut, BOut, EXE_CMDOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut,
                DestOut, iOut, RnOut, regFileInp2Out, shiftOperandOut, immOut);

    parameter N = 32;
    input wire[0:0] clk, rst, MEM_W_ENIn, WB_ENIn;
    input wire[3:0] WB_DestIn;
    input wire[N - 1:0] PCIn, instrIn, WB_ValueIn;
    output wire[N - 1:0] PCOut, val_RnOut, val_RmOut;
    output wire[0:0] Two_srcOut, statusIn, SOut, BOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut, iOut;
    output wire[3:0] EXE_CMDOut, DestOut, RnOut, regFileInp2Out;
    output wire[11:0] shiftOperandOut;
    output wire[23:0] immOut;

    wire[1:0] mode;
    assign mode = instructionIn[27:26];

    wire[3:0] opCode;
    assign opCode = instructionIn[24:21];

    wire[0:0] s;
    assign s = instructionIn[20];

    wire[3:0] rn;
    assign rn = instructionIn[19:16];
    assign RnOut = rn;

    wire[3:0] rd;
    assign rd = instructionIn[15:12];
    assign DestOut = rd;

    wire[3:0] rm;
    assign rm = instructionIn[3:0];

    wire[3:0] cond;
    assign cond = instructionIn[31:28];

    assign shiftOperandOut = instructionIn[11:0];
    assign immOut = instructionIn[23:0];

    wire[0:0] i;
    assign i = instructionIn[25];
    assign iOut = i;

    wire[3:0] readReg2;
    assign regInp2 = (~MEM_W_ENIn) ? rm : rd;
    assign regFileInp2Out = regInp2;

    RegisterFile registerFile(.clk(clk), .regWrite(WB_ENIn),
                    .readRegister1(rn), .readRegister2(regInp2),
                    .writeRegister(WB_DestIn), .writeData(WB_ValueIn),
                    .readData1(val_RnOut), .readData2(val_RmOut));

    
    assign Two_srcOut = ~i | MEM_W_ENIn;

    wire[0:0] conditionCheckOut;
    ConditionCheck conditionCheck(.condIn(cond), .condOut(conditionCheckOut), .statusIn(statusIn));

    wire[0:0] conditionCheckOutOrHazard;
    assign conditionCheckOutOrHazard = conditionCheckOut | HazardIn;

    wire[8:0] controlUnitOut
    ControlUnit controlUnit(.opCodeIn(opCode), SIn(s), .modeIn(mode), 
                            .EXE_CMDOut(controlUnitOut[3:0]), .SOut(controlUnitOut[4]), .BOut(controlUnitOut[5]), 
                            .MEM_W_ENOut(controlUnitOut[6]), .MEM_R_ENOut(controlUnitOut[7]), .WB_ENOut(controlUnitOut[8]));

    wire[8:0] muxOut;
    assign muxOut = (~conditionCheckOutOrHazard) ? controlUnit : 9'b0;

    assign EXE_CMDOut = muxOut[3:0];
    assign SOut = muxOut[4];
    assign BOut = muxOut[5];
    assign MEM_W_ENOut = muxOut[6];
    assign MEM_R_ENOut = muxOut[7];
    assign WB_ENOut = muxOut[8];

    assign PCOut = PCIn;
endmodule