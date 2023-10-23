module CPU(clk, rst);

    input clk, rst;

    wire[31:0] PCPlus4, PCD, PCEX, PCMEM, PCWB, PCEX_Reg, PCMEM_Reg, PCWB_Reg, PCF, instructionF, instructionD;
	
	IF_Stage instFetch(
		.PCF(PCPlus4), .instructionF(instructionF), .clk(clk), .rst(rst),
		.freezeF(1'b0), .branchAdderF(32'b0), .branchTakenF(1'b0)
	); //FIXME add signals

	IF_Stage_Reg instFetchReg(.clk(clk), .rst(rst), .en(1'b1), .clr(1'b0), .instrF(instructionF), .instrD(instructionD), .PCF(PCPlus4), .PCD(PCD));

	//ID_Stage instDecode(.clk(clk), .rst(rst), .PCD(PCD), .PCEX(PCEX));

	ID_Stage_Reg instDecodeReg(.clk(clk), .rst(rst), .PCD(PCD), .PCEX(PCEX));

	//EXE_Stage execute(.clk(clk), .rst(rst), .PCEX(PCEX), .PCMEM(PCMEM));

	EXE_Stage_Reg executeReg(.clk(clk), .rst(rst), .PCEX(PCEX), .PCMEM(PCMEM));

	//MEM_Stage memory(.clk(clk), .rst(rst), .PCMEM(PCMEM), .PCWB(PCWB));

	MEM_Stage_Reg memoryReg(.clk(clk), .rst(rst), .PCMEM(PCMEM), .PCWB(PCWB));

	//WB_Stage writeBack(.clk(clk), .rst(rst), .PCWB(PCWB), .PCF(PCF));

endmodule