module CPU(clk, rst);

    input clk, rst;

    wire[31:0] IF_IFR_PC, IFR_ID_PC, ID_IDR_PC, IDR_EX_PC, EX_EXR_PC, EXR_MEM_PC, MEM_MEMR_PC, MEMR_WB_PC, WB_WBR_PC, IF_IFR_Instruction, IFR_ID_Instruction;
	
	IF_Stage instFetch(
		.IF_IFR_PC(IF_IFR_PC), .IF_IFR_Instruction(IF_IFR_Instruction), .clk(clk), .rst(rst),
		.freeze(1'b0), .MEM_MEMR_branchAdder(32'b0), .branchTakenMem(1'b0)
	); 

	IF_Stage_Reg instFetchReg(.clk(clk), .rst(rst), .en(1'b1), .clr(1'b0), .instrIn(IF_IFR_Instruction), .instrOut(IFR_ID_Instruction), .PCIn(IF_IFR_PC), .PCOut(IFR_ID_PC));

	ID_Stage instDecode(.clk(clk), .rst(rst), .PCIn(IFR_ID_PC), .PCOut(ID_IDR_PC));

	ID_Stage_Reg instDecodeReg(.clk(clk), .rst(rst), .PCIn(ID_IDR_PC), .PCOut(IDR_EX_PC));

	EXE_Stage execute(.clk(clk), .rst(rst), .PCIn(IDR_EX_PC), .PCOut(EX_EXR_PC));

	EXE_Stage_Reg executeReg(.clk(clk), .rst(rst), .PCIn(EX_EXR_PC), .PCOut(EXR_MEM_PC));

	MEM_Stage memory(.clk(clk), .rst(rst), .PCIn(EXR_MEM_PC), .PCOut(MEM_MEMR_PC));

	MEM_Stage_Reg memoryReg(.clk(clk), .rst(rst), .PCIn(MEM_MEMR_PC), .PCOut(MEMR_WB_PC));

	WB_Stage writeBack(.clk(clk), .rst(rst));

endmodule