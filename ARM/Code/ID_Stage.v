
module ID_Stage(clk, rst, instructionIn, WB_ENIn, WB_DestIn, WB_ValueIn, 
                HazardIn, statusIn, Val_RnOut, Val_RmOut, 
                TwoSrcOut, SOut, BOut, EXE_CMDOut, MEM_W_ENOut, MEM_R_ENOut,
                DestOut, IOut, shiftOperandOut, 
                WB_ENOut, Imm24Out, src1Out, src2Out);

    parameter N = 32;
    
    input wire[0:0] clk, rst, WB_ENIn, HazardIn;
    input wire[3:0] WB_DestIn, statusIn;
    input wire[N - 1:0] instructionIn, WB_ValueIn;

    output wire[N - 1:0] Val_RnOut, Val_RmOut;
    output wire[0:0] TwoSrcOut, SOut, BOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut, IOut;
    output wire[3:0] EXE_CMDOut, DestOut, src1Out, src2Out;
    output wire[11:0] shiftOperandOut;
    output wire[23:0] Imm24Out;

    // --------------------- Divide Instruction ---------------------
    
    // For data processing instructions
    assign shiftOperandOut = instructionIn[11:0];

    // For instructions with immediate shift
    wire[3:0] rm;
    assign rm = instructionIn[3:0];

    // For B-type instructions
    assign Imm24Out = instructionIn[23:0];

    wire[3:0] rd;
    assign rd = instructionIn[15:12];
    assign DestOut = rd;

    wire[3:0] rn;
    assign rn = instructionIn[19:16];
    assign src1Out = rn;

    wire[0:0] s;
    assign s = instructionIn[20];

    wire[3:0] opCode;
    assign opCode = instructionIn[24:21];

    wire[0:0] i;
    assign i = instructionIn[25];
    assign IOut = i;

    wire[1:0] mode;
    assign mode = instructionIn[27:26];

    wire[3:0] cond;
    assign cond = instructionIn[31:28];
    // ---------------------------------------------------------------

    // --------------------- Control Unit ---------------------
    wire[8:0] controlUnitOut;
    ControlUnit controlUnit(  // For extracting control signals based on instruction opcode and mode
        .opCodeIn(opCode), .SIn(s),       .modeIn(mode), 
        .EXE_CMDOut(controlUnitOut[3:0]), .SOut(controlUnitOut[4]), 
        .BOut(controlUnitOut[5]),         .MEM_W_ENOut(controlUnitOut[6]), 
        .MEM_R_ENOut(controlUnitOut[7]),  .WB_ENOut(controlUnitOut[8])
    );

    wire[0:0] conditionCheckOut;
    ConditionCheck conditionCheck(  // ARM is a conditional execution architecture so we need to check the condition
        .condIn(cond), .condOut(conditionCheckOut), .statusIn(statusIn)
    );

    // For checking if instruction should be executed or if it's a NOP
    wire[0:0] controlSignalsSelector;
    assign controlSignalsSelector = (~conditionCheckOut) | HazardIn;

    wire[8:0] signals;
    Mux2to1 #(9) controlSignalsMux(
        .a(controlUnitOut), .b(9'b0), .s(controlSignalsSelector), .out(signals)
    );

    assign EXE_CMDOut  = signals[3:0];
    assign SOut        = signals[4];
    assign BOut        = signals[5];
    assign MEM_W_ENOut = signals[6]; 
    assign MEM_R_ENOut = signals[7];
    assign WB_ENOut    = signals[8];
    // -------------------------------------------------------


    // --------------------- Register File ---------------------
    wire[3:0] regfileInp2;
    Mux2to1 #(4) regfileInp2Mux(
        .a(rm), .b(rd), .s(controlUnitOut[6]), .out(regfileInp2)        
    );
    assign src2Out = regfileInp2;

    wire [0:0] notBranch;
    assign notBranch = ~controlUnitOut[5];

    RegisterFile registerFile(
        .clk(clk),                 .rst(rst), 
        .regWrite(WB_ENIn),        .regRead(notBranch),
        .readRegister1(rn),        .readRegister2(regfileInp2),
        .writeRegister(WB_DestIn), .writeData(WB_ValueIn),
        .readData1(Val_RnOut),     .readData2(Val_RmOut)
    );
    // ---------------------------------------------------------

    // For Hazard Detection Unit
    assign TwoSrcOut = ~i | controlUnitOut[6];

endmodule
