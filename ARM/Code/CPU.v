module CPU(clk, rst);

    input clk, rst;

    wire[31:0] 
		// IF IFR ID
		IF_IFR_PC, IFR_ID_PC, 
		IF_IFR_Instruction, IFR_ID_Instruction,
		// ID IDR EXE
		ID_IDR_PC, IDR_EX_PC, 
		ID_IDR_WB_EN, IDR_EX_WB_EN, 
		ID_IDR_MEM_R_EN, IDR_EX_MEM_R_EN, 
		ID_IDR_MEM_W_EN, IDR_EX_MEM_W_EN, 
		ID_IDR_EXE_CMD, IDR_EX_EXE_CMD, 
		ID_IDR_B, IDR_EX_B, 
		ID_IDR_S, IDR_EX_S, 
		ID_IDR_Val_Rn, IDR_EX_Val_Rn, 
		ID_IDR_Val_Rm, IDR_EX_Val_Rm, 
		// EXE EXER MEM 
		EX_EXR_PC, EXR_MEM_PC, MEM_MEMR_PC, MEMR_WB_PC, WB_WBR_PC;
	
	IF_Stage instFetch(
		.IF_IFR_PC(IF_IFR_PC), .IF_IFR_Instruction(IF_IFR_Instruction),
		.freeze(1'b0),  .clk(clk), .rst(rst),
		.MEM_MEMR_branchAdder(32'b0), .branchTakenMem(1'b0)
	); 

	IF_Stage_Reg instFetchReg(
		.clk(clk), .rst(rst), .en(1'b1), .clr(1'b0), 
		.instrIn(IF_IFR_Instruction), .instrOut(IFR_ID_Instruction), 
		.PCIn(IF_IFR_PC), .PCOut(IFR_ID_PC)
	);

	ID_Stage instDecode(
		.clk(clk), .rst(rst), .PCIn(IFR_ID_PC), .PCOut(ID_IDR_PC),
		.instructionIn(IFR_ID_Instruction)
	);

	ID_Stage_Reg instDecodeReg(
		.clk(clk), .rst(rst), 
		.PCIn(ID_IDR_PC), 			  .PCOut(IDR_EX_PC),
		.WB_ENIn(ID_IDR_WB_EN), 	  .WB_ENOut(IDR_EX_WB_EN), 
		.MEM_R_ENIn(ID_IDR_MEM_R_EN), .MEM_R_ENOut(IDR_EX_MEM_R_EN), 
		.MEM_W_ENIn(ID_IDR_MEM_W_EN), .MEM_W_ENOut(IDR_EX_MEM_W_EN),
		.EXE_CMDIn(ID_IDR_EXE_CMD),   .EXE_CMDOut(IDR_EX_EXE_CMD), 
		.BIn(ID_IDR_B), 	      	  .BOut(IDR_EX_B),
		.SIn(ID_IDR_S), 	      	  .SOut(IDR_EX_S),
		.Val_RmIn(ID_IDR_Val_Rm), 	  .Val_RmOut(IDR_EX_Val_Rm),
		.Val_RnIn(ID_IDR_Val_Rn), 	  .Val_RnOut(IDR_EX_Val_Rn),
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