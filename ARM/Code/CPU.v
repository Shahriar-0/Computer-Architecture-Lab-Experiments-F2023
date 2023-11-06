module CPU(clk, rst);

    input clk, rst;

    wire[31:0] 
		// IF IFR ID
		IF_IFR_PC, IFR_ID_PC, 
		IF_IFR_Instruction, IFR_ID_Instruction,
		IFR_ID_MEM_W,
		// TODO Complete these wires for instance
		// ID IDR EX
		ID_IDR_PC, IDR_EX_PC,  
		ID_IDR_Val_Rn, IDR_EX_Val_Rn, 
		ID_IDR_Val_Rm, IDR_EX_Val_Rm, 
		// EX EXR MEM 
		EX_EXR_PC, EXR_MEM_PC,
		// MEM MEMR WB
		MEM_MEMR_PC, MEMR_WB_PC, WB_WBR_PC,
		// general
		StatusRegIn, StatusRegOut,
		// WB ID
		WB_ID_WB_Value;

	wire[3:0]
		WB_ID_WB_Dest, 
		STAT_ID, STAT_IDR, IDR_STAT,
		ID_IDR_Dest, IDR_EX_Dest, 
		ID_IDR_EXE_CMD, IDR_EX_EXE_CMD,
		ID_HZ_RegSrc2;

	wire[11:0]
		ID_IDR_ShiftOperand, IDR_EX_ShiftOperand;

	wire[23:0]
		ID_IDR_Imm24, IDR_EX_Imm24;

	wire [0:0] 
		ID_IDR_WB_EN, IDR_EX_WB_EN, 
		ID_IDR_MEM_R_EN, IDR_EX_MEM_R_EN, 
		ID_IDR_MEM_W_EN, IDR_EX_MEM_W_EN, 
		ID_IDR_B, IDR_EX_B, 
		ID_IDR_S, IDR_EX_S,
		WB_ID_WB_EN, 
		ID_IDR_I, IDR_EX_I,
		HZ_ID_Hazard, ID_HZ_Two_Src; 
	
	IF_Stage instFetch(
		.clk(clk), .rst(rst),    .freeze(1'b0),
		.PCOut(IF_IFR_PC),       .instructionOut(IF_IFR_Instruction),  
		.branchAddressIn(32'b0), .branchTakenIn(1'b0)
	); 

	IF_Stage_Reg instFetchReg(
		.clk(clk), .rst(rst),         .en(1'b1), .clr(1'b0), 
		.instrIn(IF_IFR_Instruction), .instrOut(IFR_ID_Instruction), 
		.PCIn(IF_IFR_PC),             .PCOut(IFR_ID_PC)
	);

	ID_Stage instDecode(
		.clk(clk),                             .rst(rst),                  
		.instructionIn(IFR_ID_Instruction),    .WB_ENIn(/*WB_ID_WB_EN*/1'b0),                 
		.WB_DestIn(WB_ID_WB_Dest),             .WB_ValueIn(WB_ID_WB_Value),           
		.HazardIn(/*HZ_ID_Hazard*/ 1'b0),      .PCIn(IFR_ID_PC),                      
		.statusIn(/*STAT_ID*/4'b0),                    .PCOut(ID_IDR_PC),                     
		.Val_RnOut(ID_IDR_Val_Rn),             .Val_RmOut(ID_IDR_Val_Rm),             
		.Two_srcOut(ID_HZ_Two_Src),            .SOut(ID_IDR_S),               
		.BOut(ID_IDR_B),                       .EXE_CMDOut(ID_IDR_EXE_CMD), 
		.MEM_W_ENOut(ID_IDR_MEM_W_EN),         .MEM_R_ENOut(ID_IDR_MEM_R_EN),      
		.WB_ENOut(ID_IDR_WB_EN),               .DestOut(ID_IDR_Dest),         
		.IOut(ID_IDR_I),                       .regFileInp2Out(ID_HZ_RegSrc2), 
		.shiftOperandOut(ID_IDR_ShiftOperand), .Imm24Out(ID_IDR_Imm24)
	);

	ID_Stage_Reg instDecodeReg(
		.clk(clk), .rst(rst),                 .en(1'b1), .clr(1'b0),
		.PCIn(ID_IDR_PC), 			          .PCOut(IDR_EX_PC),
		.WB_ENIn(ID_IDR_WB_EN), 	          .WB_ENOut(IDR_EX_WB_EN), 
		.MEM_R_ENIn(ID_IDR_MEM_R_EN),         .MEM_R_ENOut(IDR_EX_MEM_R_EN), 
		.MEM_W_ENIn(ID_IDR_MEM_W_EN),         .MEM_W_ENOut(IDR_EX_MEM_W_EN),
		.EXE_CMDIn(ID_IDR_EXE_CMD),           .EXE_CMDOut(IDR_EX_EXE_CMD), 
		.BIn(ID_IDR_B), 	      	          .BOut(IDR_EX_B),
		.SIn(ID_IDR_S), 	      	          .SOut(IDR_EX_S),
		.Val_RmIn(ID_IDR_Val_Rm), 	          .Val_RmOut(IDR_EX_Val_Rm),
		.Val_RnIn(ID_IDR_Val_Rn), 	          .Val_RnOut(IDR_EX_Val_Rn),
		.shiftOperandIn(ID_IDR_ShiftOperand), .shiftOperandOut(IDR_EX_ShiftOperand), 
		.IIn(ID_IDR_I),                       .IOut(IDR_EX_I),      
		.Imm24In(ID_IDR_Imm24),               .Imm24Out(IDR_EX_Imm24), 
		.DestIn(ID_IDR_Dest),                 .DestOut(IDR_EX_Dest), 
		.statusIn(STAT_IDR),                  .statusOut(IDR_STAT)
	);

	EXE_Stage execute(
		.clk(clk), .rst(rst), .PCIn(IDR_EX_PC), .PCOut(EX_EXR_PC)
	);

	EXE_Stage_Reg executeReg(
		.clk(clk), .rst(rst), .PCIn(EX_EXR_PC), .PCOut(EXR_MEM_PC)
	);

	MEM_Stage memory(
		.clk(clk), .rst(rst), .PCIn(EXR_MEM_PC), .PCOut(MEM_MEMR_PC)
	);

	MEM_Stage_Reg memoryReg(
		.clk(clk), .rst(rst), .PCIn(MEM_MEMR_PC), .PCOut(MEMR_WB_PC)
	);

	WB_Stage writeBack(
		.clk(clk), .rst(rst)
	);

endmodule