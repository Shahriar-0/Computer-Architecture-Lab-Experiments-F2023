module CPU(clk, rst, forwardENIn,
		   MEM_SRAM_DQ, MEM_SRAM_ADDR, MEM_SRAM_UB_N, 
		   MEM_SRAM_LB_N, MEM_SRAM_WE_N, MEM_SRAM_CE_N, 
		   MEM_SRAM_OE_N);

    input clk, rst, forwardENIn;
	inout wire[15:0] MEM_SRAM_DQ;
	output wire[17:0] MEM_SRAM_ADDR;
	output wire[0:0]  MEM_SRAM_UB_N, MEM_SRAM_LB_N, MEM_SRAM_WE_N, 
					  MEM_SRAM_CE_N, MEM_SRAM_OE_N;

    wire[31:0] 
		IF_Pc, IFR_Pc, IF_Instr, IFR_Instr, IFR_ID_MEM_W, MEM_DataMemory,
		ID_IDR_PC, IDR_Pc, ID_ValRn, IDR_ValRn, ID_ValRm, IDR_ValRm, 
		EX_ALU, MEM_MEMR_ALU, MEM_MEMR_PC, MEMR_WB_PC, WB_WBR_PC, 
		MEM_MEMR_MemoryData, MEMR_Alu, MEMR_DataMemory, EXR_Alu, EXR_ValRm,
		StatusRegIn, StatusRegOut, WB_WriteBackValue, EX_BranchAddress;

	wire[3:0]
		WB_Dest, 
		IDR_Status, EX_Status, STAT_Out,
		ID_Dest, IDR_Dest, 
		ID_Src1, ID_Src2, EXR_Dest,  
		IDR_Src1, IDR_Src2,  
		ID_ExeCmd, IDR_ExeCmd,
		MEM_MEMR_Dest, MEMR_Dest;

	wire[11:0]
		ID_ShiftOperand, IDR_ShiftOperand;

	wire[23:0]
		ID_Imm24, IDR_Imm24;

	wire[0:0] 
		ID_WriteBackEn, IDR_WriteBackEn, ID_MemReadEn, IDR_MemReadEn, 
		ID_MemWriteEn, IDR_MemWriteEn, ID_b, BranchTaken, 
		ID_s, IDR_s, ID_TwoSrc, WB_WriteBackEn, ID_i, IDR_i,
		HazardSignal, MEM_MEMR_WB_EN, MEMR_WriteBackEn, MEMR_MemReadEn,
		MEM_Ready, EXR_WriteBackEn, EXR_MemReadEn, EXR_MemWriteEN; 

	wire[1:0]
		FW_SelSrc1, FW_SelSrc2;


	IF_Stage instFetch(
		.clk(clk), .rst(rst),                   .freeze(HazardSignal | ~MEM_Ready),
		.PCOut(IF_Pc),                          .instructionOut(IF_Instr),  
		.branchAddressIn(EX_BranchAddress), 	.branchTakenIn(BranchTaken)
	); 

	
	IF_Stage_Reg instFetchReg(
		.clk(clk), .rst(rst),         .en(~HazardSignal & MEM_Ready), .clr(BranchTaken), 
		.instrIn(IF_Instr), 		  .instrOut(IFR_Instr), 
		.PCIn(IF_Pc),                 .PCOut(IFR_Pc)
	);


	ID_Stage instDecode(
		.clk(clk), .rst(rst),         .IOut(ID_i),      
		.instructionIn(IFR_Instr),    .WB_ENIn(WB_WriteBackEn),                 
		.WB_DestIn(WB_Dest),          .WB_ValueIn(WB_WriteBackValue),           
		.HazardIn(HazardSignal),      .Imm24Out(ID_Imm24),		                          
		.statusIn(STAT_Out),          .shiftOperandOut(ID_ShiftOperand),                           
		.Val_RnOut(ID_ValRn),         .Val_RmOut(ID_ValRm),             
		.TwoSrcOut(ID_TwoSrc),        .SOut(ID_s),               
		.BOut(ID_b),                  .EXE_CMDOut(ID_ExeCmd), 
		.MEM_W_ENOut(ID_MemWriteEn),  .MEM_R_ENOut(ID_MemReadEn),      
		.WB_ENOut(ID_WriteBackEn),    .DestOut(ID_Dest),         
		.src1Out(ID_Src1), 			  .src2Out(ID_Src2)
	);


	HazardUnit hazardUnit(
		.Src1In(ID_Src1),             .Src2In(ID_Src2), 
		.TwoSrcIn(ID_TwoSrc),      	  .EXE_DestIn(IDR_Dest), 
		.MEM_DestIn(MEM_MEMR_Dest),   .EXE_WB_ENIn(IDR_WriteBackEn), 
		.MEM_WB_ENIn(MEM_MEMR_WB_EN), .MEM_R_ENIn(IDR_MemReadEn), 
		.forwardENIn(forwardENIn),    .HazardOut(HazardSignal)
	);


	ID_Stage_Reg instDecodeReg(
		.clk(clk), .rst(rst),             .en(MEM_Ready), .clr(BranchTaken),
		.PCIn(IFR_pc), 			          .PCOut(IDR_Pc),
		.WB_ENIn(ID_WriteBackEn), 	      .WB_ENOut(IDR_WriteBackEn), 
		.MEM_R_ENIn(ID_MemReadEn),        .MEM_R_ENOut(IDR_MemReadEn), 
		.MEM_W_ENIn(ID_MemWriteEn),       .MEM_W_ENOut(IDR_MemWriteEn),
		.EXE_CMDIn(ID_ExeCmd),            .EXE_CMDOut(IDR_ExeCmd), 
		.BIn(ID_b), 	      	          .BOut(BranchTaken),
		.SIn(ID_s), 	      	          .SOut(IDR_s),
		.Val_RmIn(ID_ValRm), 	          .Val_RmOut(IDR_ValRm),
		.Val_RnIn(ID_ValRn), 	          .Val_RnOut(IDR_ValRn),
		.shiftOperandIn(ID_ShiftOperand), .shiftOperandOut(IDR_ShiftOperand), 
		.IIn(ID_i),                       .IOut(IDR_i),      
		.Imm24In(ID_Imm24),               .Imm24Out(IDR_Imm24), 
		.DestIn(ID_Dest),                 .DestOut(IDR_Dest), 
		.statusIn(STAT_Out),              .statusOut(IDR_Status),
		.src1In(ID_Src1),   		      .src1Out(IDR_Src1),
		.src2In(ID_Src2),   		      .src2Out(IDR_Src2)
	);


	EXE_Stage execute(
		.clk(clk), .rst(rst),                    
		.MEM_R_ENIn(IDR_MemReadEn),            .MEM_W_ENIn(IDR_MemWriteEn), 
		.EXE_CMDIn(IDR_ExeCmd),                .PCIn(IDR_Pc), 
		.Val_RnIn(IDR_ValRn),                  .Val_RmIn(IDR_ValRm), 
		.shiftOperandIn(IDR_ShiftOperand),     .IIn(IDR_i), 
		.Imm24In(IDR_Imm24),                   .ALU_ResIn(EXR_Alu),
		.statusIn(IDR_Status),                 .ALU_ResOut(EX_ALU),   
		.WB_ValueIn(WB_WriteBackValue),  	   .statusOut(EX_Status),     
		.selSrc1In(FW_SelSrc1),     		   .selSrc2In(FW_SelSrc2),	 
		.branchAddressOut(EX_BranchAddress)
	);


	EXE_Stage_Reg executeReg(
		.clk(clk), .rst(rst),            .en(MEM_Ready), .clr(1'b0), 
		.WB_ENIn(IDR_WriteBackEn),       .WB_ENOut(EXR_WriteBackEn), 
		.MEM_R_ENIn(IDR_MemReadEn),  	 .MEM_R_ENOut(EXR_MemReadEn), 
		.MEM_W_ENIn(IDR_MemWriteEn), 	 .MEM_W_ENOut(EXR_MemWriteEN), 
		.ALU_ResIn(EX_ALU),        		 .ALU_ResOut(EXR_Alu), 
		.Val_RmIn(IDR_ValRm),      		 .Val_RmOut(EXR_ValRm), 
		.DestIn(IDR_Dest),         		 .DestOut(EXR_Dest)
	);


	StatusRegister statusRegister(
		.clk(clk), .rst(rst),   .en(IDR_s), 
		.statIn(EX_Status),     .statOut(STAT_Out)
	);


	MEM_Stage memoryStage(
		.clk(clk), .rst(rst),         .ALU_ResIn(EXR_Alu), 
		.MEM_W_ENIn(EXR_MemWriteEN),  .MEM_R_ENIn(EXR_MemReadEn), 
		.Value_RmIn(EXR_ValRm),       .DataMemoryOut(MEM_DataMemory), 
		.MEM_ReadyOut(MEM_Ready),     .SRAM_DQInOut(MEM_SRAM_DQ), 
		.SRAM_ADDROut(MEM_SRAM_ADDR), .SRAM_UB_NOut(MEM_SRAM_UB_N), 
		.SRAM_LB_NOut(MEM_SRAM_LB_N), .SRAM_WE_NOut(MEM_SRAM_WE_N), 
		.SRAM_CE_NOut(MEM_SRAM_CE_N), .SRAM_OE_NOut(MEM_SRAM_OE_N)
	);


	MEM_Stage_Reg memoryReg(
		.clk(clk), .rst(rst),          .clr(1'b0), .en(MEM_Ready), 
		.WB_ENIn(EXR_WriteBackEn),     .WB_ENOut(MEMR_WriteBackEn), 
		.MEM_R_ENIn(EXR_MemReadEn),    .MEM_R_ENOut(MEMR_MemReadEn), 
		.ALU_ResIn(EXR_Alu),           .ALU_ResOut(MEMR_Alu), 
		.DataMemoryIn(MEM_DataMemory), .DataMemoryOut(MEMR_DataMemory), 
		.DestIn(EXR_Dest),             .DestOut(MEMR_Dest)
	);


	ForwardingUnit forward(
		.forwardEnIn(forwardENIn), 
		.src1In(IDR_Src1), 			   	     .src2In(IDR_Src2), 
		.MEM_MEMR_WB_ENIn(EXR_WriteBackEn),  .WB_ID_WB_ENIn(WB_WriteBackEn), 
		.MEM_MEMR_DestIn(EXR_Dest),   		 .WB_ID_WB_DestIn(WB_Dest), 
		.selSrc1Out(FW_SelSrc1), 		     .selSrc2Out(FW_SelSrc2)
	);


	WB_Stage writeBack(
		.clk(clk), .rst(rst),         .WB_DestIn(MEMR_Dest),   
		.ALU_ResIn(MEMR_Alu),         .DataMemoryIn(MEMR_DataMemory), 
		.MEM_R_ENIn(MEMR_MemReadEn),  .WB_ENIn(MEMR_WriteBackEn),
		.WB_DestOut(WB_Dest),         .WB_ValueOut(WB_WriteBackValue)
		.WB_ENOut(WB_WriteBackEn),       
	);

endmodule
