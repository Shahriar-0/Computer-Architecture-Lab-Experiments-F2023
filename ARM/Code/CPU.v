module CPU(clk, rst, forwardENIn,
		   SC_SRAM_DQ, SC_SRAM_ADDR, SC_SRAM_UB_N, 
		   SC_SRAM_LB_N, SC_SRAM_WE_N, SC_SRAM_CE_N, 
		   SC_SRAM_OE_N, SC_READ_DATA);

    input clk, rst, forwardENIn;

    wire[31:0] 
		// IF IFR ID
		IF_IFR_PC, IFR_ID_PC, 
		IF_IFR_Instruction, IFR_ID_Instruction,
		IFR_ID_MEM_W,
		// ID IDR EX
		ID_IDR_PC, IDR_EX_PC,  
		ID_IDR_Val_Rn, IDR_EX_Val_Rn, 
		ID_IDR_Val_Rm, IDR_EX_Val_Rm, 
		// EX EXR MEM 
		EX_EXR_ALU, EX_EXR_Val_Rm, EXR_MEMR_ALU, EXR_MEM_Val_Rm, MEM_MEMR_ALU,
		// MEM MEMR WB
		MEM_MEMR_PC, MEMR_WB_PC, WB_WBR_PC, MEM_MEMR_MemoryData, MEMR_WB_ALU, MEMR_WB_MemoryData,
		// general
		StatusRegIn, StatusRegOut,
		// WB ID
		WB_ID_WB_Value,

		EX_IF_Branch_Address;

	wire[3:0]
		WB_ID_WB_Dest, 
		IDR_STAT, EX_STAT, STAT_Out,
		ID_IDR_Dest, IDR_EX_Dest, 
		ID_IDR_src1, ID_IDR_src2,  
		IDR_EX_src1, IDR_EX_src2,  
		ID_IDR_EXE_CMD, IDR_EX_EXE_CMD,
		EX_EXR_Dest, EXR_MEMR_Dest, MEM_MEMR_Dest, MEMR_WB_Dest,
		ID_HZ_RegSrc2, ID_HZ_Rn;

	wire[11:0]
		ID_IDR_ShiftOperand, IDR_EX_ShiftOperand;

	wire[23:0]
		ID_IDR_Imm24, IDR_EX_Imm24;

	wire[31:0]
			MEM_EX_ALU_Res;
	wire[0:0] 
		ID_IDR_WB_EN, IDR_EX_WB_EN, 
		ID_IDR_MEM_R_EN, IDR_EX_MEM_R_EN, 
		ID_IDR_MEM_W_EN, IDR_EX_MEM_W_EN, 
		ID_IDR_B, BranchTaken, 
		ID_IDR_S, IDR_EX_S,
		WB_ID_WB_EN, 
		ID_IDR_I, IDR_EX_I,
		HazardOut,
		EX_EXR_WB_EN, EX_EXR_MEM_R_EN, EX_EXR_MEM_W_EN, EX_STAT_EN, 
		EXR_MEMR_WB_EN, EXR_MEMR_MEM_R_EN, EXR_MEM_MEM_W_EN,
		MEM_MEMR_WB_EN,
		MEMR_WB_WB_EN, MEMR_WB_MEM_R_EN,
		SC_READY; 

	wire[1:0]
		selSrc1, selSrc2;

	inout wire[15:0] SC_SRAM_DQ;
	output wire[17:0] SC_SRAM_ADDR;
	output wire[0:0]  SC_SRAM_UB_N, SC_SRAM_LB_N, SC_SRAM_WE_N, SC_SRAM_CE_N, SC_SRAM_OE_N;
	output wire[31:0] SC_READ_DATA;	

	IF_Stage instFetch(
		.clk(clk), .rst(rst),    .freeze(HazardOut | ~SC_READY),
		.PCOut(IF_IFR_PC),       .instructionOut(IF_IFR_Instruction),  
		.branchAddressIn(EX_IF_Branch_Address), .branchTakenIn(BranchTaken)
	); 

	IF_Stage_Reg instFetchReg(
		.clk(clk), .rst(rst),         .en(~HazardOut & SC_READY), .clr(BranchTaken), 
		.instrIn(IF_IFR_Instruction), .instrOut(IFR_ID_Instruction), 
		.PCIn(IF_IFR_PC),             .PCOut(IFR_ID_PC)
	);

	ID_Stage instDecode(
		.clk(clk), .rst(rst),                  .src2Out(ID_IDR_src2),
		.instructionIn(IFR_ID_Instruction),    .WB_ENIn(WB_ID_WB_EN),                 
		.WB_DestIn(WB_ID_WB_Dest),             .WB_ValueIn(WB_ID_WB_Value),           
		.HazardIn(HazardOut),      			   .PCIn(IFR_ID_PC),                      
		.statusIn(STAT_Out),                   .PCOut(ID_IDR_PC),                     
		.Val_RnOut(ID_IDR_Val_Rn),             .Val_RmOut(ID_IDR_Val_Rm),             
		.TwoSrcOut(ID_HZ_TwoSrc),              .SOut(ID_IDR_S),               
		.BOut(ID_IDR_B),                       .EXE_CMDOut(ID_IDR_EXE_CMD), 
		.MEM_W_ENOut(ID_IDR_MEM_W_EN),         .MEM_R_ENOut(ID_IDR_MEM_R_EN),      
		.WB_ENOut(ID_IDR_WB_EN),               .DestOut(ID_IDR_Dest),         
		.IOut(ID_IDR_I),                       .regFileInp2Out(ID_HZ_RegSrc2),
		.RnOut(ID_HZ_Rn),					   .Imm24Out(ID_IDR_Imm24),
		.src1Out(ID_IDR_src1), 				   .shiftOperandOut(ID_IDR_ShiftOperand)
	);

	HazardUnit hazardUnit(
		.RnIn(ID_HZ_Rn),              .reg2In(ID_HZ_RegSrc2), 
		.TwoSrcIn(ID_HZ_TwoSrc),      .EXE_DestIn(EX_EXR_Dest), 
		.MEM_DestIn(MEM_MEMR_Dest),   .EXE_WB_ENIn(EX_EXR_WB_EN), 
		.MEM_WB_ENIn(MEM_MEMR_WB_EN), .MEM_R_ENIn(IDR_EX_MEM_R_EN), 
		.forwardENIn(forwardENIn),    .HazardOut(HazardOut)
	);

	ID_Stage_Reg instDecodeReg(
		.clk(clk), .rst(rst),                 .en(SC_READY), .clr(BranchTaken),
		.PCIn(ID_IDR_PC), 			          .PCOut(IDR_EX_PC),
		.WB_ENIn(ID_IDR_WB_EN), 	          .WB_ENOut(IDR_EX_WB_EN), 
		.MEM_R_ENIn(ID_IDR_MEM_R_EN),         .MEM_R_ENOut(IDR_EX_MEM_R_EN), 
		.MEM_W_ENIn(ID_IDR_MEM_W_EN),         .MEM_W_ENOut(IDR_EX_MEM_W_EN),
		.EXE_CMDIn(ID_IDR_EXE_CMD),           .EXE_CMDOut(IDR_EX_EXE_CMD), 
		.BIn(ID_IDR_B), 	      	          .BOut(BranchTaken),
		.SIn(ID_IDR_S), 	      	          .SOut(IDR_EX_S),
		.Val_RmIn(ID_IDR_Val_Rm), 	          .Val_RmOut(IDR_EX_Val_Rm),
		.Val_RnIn(ID_IDR_Val_Rn), 	          .Val_RnOut(IDR_EX_Val_Rn),
		.shiftOperandIn(ID_IDR_ShiftOperand), .shiftOperandOut(IDR_EX_ShiftOperand), 
		.IIn(ID_IDR_I),                       .IOut(IDR_EX_I),      
		.Imm24In(ID_IDR_Imm24),               .Imm24Out(IDR_EX_Imm24), 
		.DestIn(ID_IDR_Dest),                 .DestOut(IDR_EX_Dest), 
		.statusIn(STAT_Out),                  .statusOut(IDR_STAT),
		.src1In(ID_IDR_src1),   		      .src1Out(IDR_EX_src1),
		.src2In(ID_IDR_src2),   		      .src2Out(IDR_EX_src2)
	);

	EXE_Stage execute(
		.clk(clk), .rst(rst),                    .WB_ENIn(IDR_EX_WB_EN), 
		.MEM_R_ENIn(IDR_EX_MEM_R_EN),            .MEM_W_ENIn(IDR_EX_MEM_W_EN), 
		.EXE_CMDIn(IDR_EX_EXE_CMD),               
		.SIn(IDR_EX_S),                          .PCIn(IDR_EX_PC), 
		.Val_RnIn(IDR_EX_Val_Rn),                .Val_RmIn(IDR_EX_Val_Rm), 
		.shiftOperandIn(IDR_EX_ShiftOperand),    .IIn(IDR_EX_I), 
		.Imm24In(IDR_EX_Imm24),                  .DestIn(IDR_EX_Dest), 
		.statusIn(STAT_Out),                     .WB_ENOut(EX_EXR_WB_EN), 
		.MEM_R_ENOut(EX_EXR_MEM_R_EN),           .MEM_W_ENOut(EX_EXR_MEM_W_EN), 
		.ALU_ResOut(EX_EXR_ALU),                 .Val_RmOut(EX_EXR_Val_Rm), 
		.DestOut(EX_EXR_Dest),                   .statusOut(EX_STAT), 
		.branchAddressOut(EX_IF_Branch_Address), .SOut(EX_STAT_EN),
		.WB_ValueIn(WB_ID_WB_Value),  		     .ALU_ResIn(EXR_MEMR_ALU),
		.selSrc1In(selSrc1),     				 .selSrc2In(selSrc2)
	);

	EXE_Stage_Reg executeReg(
		.clk(clk), .rst(rst),         .en(SC_READY), .clr(1'b0), 
		.WB_ENIn(EX_EXR_WB_EN),       .WB_ENOut(EXR_MEMR_WB_EN), 
		.MEM_R_ENIn(EX_EXR_MEM_R_EN), .MEM_R_ENOut(EXR_MEMR_MEM_R_EN), 
		.MEM_W_ENIn(EX_EXR_MEM_W_EN), .MEM_W_ENOut(EXR_MEM_MEM_W_EN), 
		.ALU_ResIn(EX_EXR_ALU),       .ALU_ResOut(EXR_MEMR_ALU), 
		.Val_RmIn(EX_EXR_Val_Rm),     .Val_RmOut(EXR_MEM_Val_Rm), 
		.DestIn(EX_EXR_Dest),         .DestOut(EXR_MEMR_Dest)
	);

	StatusRegister statusRegister(
		.clk(clk), .rst(rst), .en(EX_STAT_EN), .statIn(EX_STAT), .statOut(STAT_Out)
	);


	// MEM_Stage memory(
	// 	.clk(clk), .rst(rst),            .ALU_ResIn(EXR_MEMR_ALU),             
	// 	.MEM_W_ENIn(EXR_MEM_MEM_W_EN),   .MEM_R_ENIn(EXR_MEMR_MEM_R_EN),       
	// 	.WB_ENIn(EXR_MEMR_WB_EN),         .Value_RmIn(EXR_MEM_Val_Rm),         
	// 	.DestIn(EXR_MEMR_Dest),           .WB_ENOut(MEM_MEMR_WB_EN),           
	// 	.MEM_R_ENOut(MEM_MEMR_MEM_R_EN), .DataMemoryOut(MEM_MEMR_MemoryData), 
	// 	.DestOut(MEM_MEMR_Dest),         .ALU_ResOut(MEM_MEMR_ALU),
	// 	.MEM_EX_ALU_ResOut(MEM_EX_ALU_Res)
	// );

	wire[31:0] cache_sram_rDataOut;
	wire [0:0] sram_cache_ready, cache_sram_w_en, cache_sram_r_en;
	wire[63:0] sram_cache_data;

	CacheController cachecontroller(
		.clk(clk), .rst(rst), .rdEnIn(EXR_MEMR_MEM_R_EN), .wrEnIn(EXR_MEM_MEM_W_EN), .adrIn(EXR_MEMR_ALU), .wDataIn(EXR_MEM_Val_Rm), 
		.rDataOut(SC_READ_DATA), .readyOut(SC_READY), .sramReadyIn(sram_cache_ready), .sramReadDataIn(sram_cache_data), 
		.sramWrEnOut(cache_sram_w_en), .sramRdEnOut(cache_sram_r_en));

	// SramController sramcontroller(
    // 	.clk(clk), .rst(rst),
    // 	.wrEnIn(cache_sram_w_en),  .rdEnIn(cache_sram_r_en),
    // 	.addressIn(EXR_MEMR_ALU),   .writeDataIn(EXR_MEM_Val_Rm),
    // 	.readDataOut(sram_cache_data), 
		
	// 	.readyOut(sram_cache_ready),            // to freeze other stages
    // 	.SRAM_DQInOut(SC_SRAM_DQ),      // SRAM Data bus 16 bits
    // 	.SRAM_ADDROut(SC_SRAM_ADDR), 	// SRAM Address bus 18 bits
    // 	.SRAM_UB_NOut(SC_SRAM_UB_N),    // SRAM High-byte data mask
    // 	.SRAM_LB_NOut(SC_SRAM_LB_N),    // SRAM Low-byte data mask
    // 	.SRAM_WE_NOut(SC_SRAM_WE_N),    // SRAM Write enable
    // 	.SRAM_CE_NOut(SC_SRAM_CE_N),    // SRAM Chip enable
    // 	.SRAM_OE_NOut(SC_SRAM_OE_N)     // SRAM Output enable
	// );

	wire[0:0] SC_SRAM_WE_;
	wire[17:0] SC_SRAM_ADD;
	wire[15:0] SC_SRAM_D;

	SramController sramcontroller(
    	.clk(clk), .rst(rst),
    	.wrEnIn(cache_sram_w_en),  .rdEnIn(cache_sram_r_en),
    	.addressIn(EXR_MEMR_ALU),   .writeDataIn(EXR_MEM_Val_Rm),
    	.readDataOut(sram_cache_data), 
		
		.readyOut(sram_cache_ready),            // to freeze other stages
    	.SRAM_DQInOut(SC_SRAM_D),      // SRAM Data bus 16 bits
    	.SRAM_ADDROut(SC_SRAM_ADD), 	// SRAM Address bus 18 bits
    	.SRAM_UB_NOut(SC_SRAM_UB_N),    // SRAM High-byte data mask
    	.SRAM_LB_NOut(SC_SRAM_LB_N),    // SRAM Low-byte data mask
    	.SRAM_WE_NOut(SC_SRAM_WE_),    // SRAM Write enable
    	.SRAM_CE_NOut(SC_SRAM_CE_N),    // SRAM Chip enable
    	.SRAM_OE_NOut(SC_SRAM_OE_N)     // SRAM Output enable
	);

	SRAM sram(
		.clk(clk), .rst(rst), 
		.SRAM_WE_NIn(SC_SRAM_WE_), .SRAM_ADDRIn(SC_SRAM_ADD), 
		.SRAM_DQInOut(SC_SRAM_D)
	);

	MEM_Stage_Reg memoryReg(
		.clk(clk), .rst(rst),               .clr(1'b0), .en(SC_READY), 
		.WB_ENIn(EXR_MEMR_WB_EN),           .WB_ENOut(MEMR_WB_WB_EN), 
		.MEM_R_ENIn(EXR_MEMR_MEM_R_EN),     .MEM_R_ENOut(MEMR_WB_MEM_R_EN), 
		.ALU_ResIn(EXR_MEMR_ALU),           .ALU_ResOut(MEMR_WB_ALU), 
		.DataMemoryIn(SC_READ_DATA), 	    .DataMemoryOut(MEMR_WB_MemoryData), 
		.DestIn(EXR_MEMR_Dest),             .DestOut(MEMR_WB_Dest)
	);

	ForwardingUnit forward(
		.forwardEnIn(forwardENIn), 
		.src1In(IDR_EX_src1), 			   .src2In(IDR_EX_src2), 
		.MEM_MEMR_WB_ENIn(EXR_MEMR_WB_EN), .WB_ID_WB_ENIn(WB_ID_WB_EN), 
		.MEM_MEMR_DestIn(EXR_MEMR_Dest),   .WB_ID_WB_DestIn(WB_ID_WB_Dest), 
		.selSrc1Out(selSrc1), 		       .selSrc2Out(selSrc2)
	);

	WB_Stage writeBack(
		.clk(clk),                     .rst(rst),           
		.ALU_ResIn(MEMR_WB_ALU),       .DataMemoryIn(MEMR_WB_MemoryData), 
		.MEM_R_ENIn(MEMR_WB_MEM_R_EN), .WB_DestIn(MEMR_WB_Dest), 
		.WB_DestOut(WB_ID_WB_Dest),    .WB_ENIn(MEMR_WB_WB_EN), 
		.WB_ENOut(WB_ID_WB_EN),        .WB_ValueOut(WB_ID_WB_Value)
	);

endmodule