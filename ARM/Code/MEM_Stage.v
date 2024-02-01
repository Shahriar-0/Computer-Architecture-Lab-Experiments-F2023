module MEM_Stage(clk, rst, ALU_ResIn, MEM_W_ENIn, MEM_R_ENIn, Value_RmIn, 
                 DataMemoryOut, MEM_ReadyOut,
                 SRAM_DQInOut, SRAM_ADDROut, SRAM_UB_NOut, SRAM_LB_NOut, SRAM_WE_NOut, SRAM_CE_NOut, SRAM_OE_NOut);

    input wire[0:0] clk, rst, MEM_W_ENIn, MEM_R_ENIn;
    input wire[31:0] ALU_ResIn, Value_RmIn;

    output wire[0:0] MEM_ReadyOut; 
    output wire[17:0] SRAM_ADDROut, SRAM_UB_NOut, SRAM_LB_NOut, SRAM_WE_NOut, SRAM_CE_NOut, SRAM_OE_NOut; 
    output wire[31:0] DataMemoryOut;

    inout wire[15:0] SRAM_DQInOut;

    wire[31:0] cache_sram_rDataOut;
	wire [0:0] sram_cache_ready, cache_sram_w_en, cache_sram_r_en;
	wire[63:0] sram_cache_data;

	CacheController cachecontroller(
		.clk(clk),                      .rst(rst), 
        .rdEnIn(MEM_R_ENIn),            .wrEnIn(MEM_W_ENIn), 
        .adrIn(ALU_ResIn),              .wDataIn(Value_RmIn), 
		.rDataOut(DataMemoryOut),       .readyOut(MEM_ReadyOut), 
        .sramReadyIn(sram_cache_ready), .sramReadDataIn(sram_cache_data), 
		.sramWrEnOut(cache_sram_w_en),  .sramRdEnOut(cache_sram_r_en)
    );

	wire[0:0] SC_SRAM_WE_;
	wire[17:0] SC_SRAM_ADD;
	wire[15:0] SC_SRAM_D;
	SramController sramcontroller(
    	.clk(clk),                    .rst(rst),
        .wrEnIn(cache_sram_w_en),     .rdEnIn(cache_sram_r_en),
    	.addressIn(ALU_ResIn),        .writeDataIn(Value_RmIn),
    	.readDataOut(sram_cache_data), 
		.readyOut(sram_cache_ready),    // to freeze other stages
    	.SRAM_DQInOut(SC_SRAM_D),       // SRAM Data bus 16 bits
    	.SRAM_ADDROut(SC_SRAM_ADD), 	// SRAM Address bus 18 bits
    	.SRAM_UB_NOut(SRAM_UB_NOut),    // SRAM High-byte data mask
    	.SRAM_LB_NOut(SRAM_LB_NOut),    // SRAM Low-byte data mask
    	.SRAM_WE_NOut(SC_SRAM_WE_),     // SRAM Write enable
    	.SRAM_CE_NOut(SRAM_CE_NOut),    // SRAM Chip enable
    	.SRAM_OE_NOut(SRAM_OE_NOut)     // SRAM Output enable
	);

	/*------------------------------------- testing mode -------------------------------------*/
	SRAM sram(
		.clk(clk), .rst(rst), 
		.SRAM_WE_NIn(SC_SRAM_WE_), .SRAM_ADDRIn(SC_SRAM_ADD), 
		.SRAM_DQInOut(SC_SRAM_D)
	);

endmodule
