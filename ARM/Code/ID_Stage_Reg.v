
module ID_Stage_Reg(clk, rst, PCIn, PCOut, WB_ENIn, WB_ENOut, 
                    MEM_R_ENIn, MEM_R_ENOut, MEM_W_ENIn, MEM_W_ENOut,
                    EXE_CMDIn, EXE_CMDOut, BIn, BOut, SIn, SOut, 
                    Val_RmIn, Val_RmOut, Val_RnIn, Val_RnOut);
    parameter N = 32;

    input wire[0:0] clk, rst;
    
    input wire [0:0] WB_ENIn, MEM_R_ENIn, MEM_W_ENIn, EXE_CMDIn, BIn, SIn;
    input wire[N - 1:0] PCIn, Val_RmIn, Val_RnIn;

    output reg[N - 1:0] PCOut, Val_RmOut, Val_RmOut;
    output reg [0:0] WB_ENOut, MEM_R_ENOut, MEM_W_ENOut, EXE_CMDOut, BOut, SOut;

    always@(posedge clk or posedge rst) begin

        if (rst) begin
            PCOut       <= 32'b0;
            WB_ENOut    <= 32'b0;
            MEM_R_ENOut <= 32'b0;
            MEM_W_ENOut <= 32'b0;
            EXE_CMDOut  <= 32'b0;
            BOut        <= 32'b0;
            SOut        <= 32'b0;
            Val_RmOut   <= 32'b0;
            Val_RnOut   <= 32'b0;
        end 
        
        else if (clr) begin
            PCOut       <= 32'b0;
			WB_ENOut    <= 32'b0;
			MEM_R_ENOut <= 32'b0;
			MEM_W_ENOut <= 32'b0;
			EXE_CMDOut  <= 32'b0;
			BOut        <= 32'b0;
			SOut        <= 32'b0;
			Val_RmOut   <= 32'b0;
			Val_RnOut   <= 32'b0;
        end

        else if (en) begin
            PCOut       <= PCIn;
			WB_ENOut    <= WB_ENIn;
			MEM_R_ENOut <= MEM_R_ENIn;
			MEM_W_ENOut <= MEM_W_ENIn;
			EXE_CMDOut  <= EXE_CMDIn;
			BOut        <= BIn;
			SOut        <= SIn;
			Val_RmOut   <= Val_RmIn;
			Val_RnOut   <= Val_RnIn;
        end
    end
endmodule