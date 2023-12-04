
module ID_Stage_Reg(clk, rst, en, clr, PCIn, PCOut, WB_ENIn, WB_ENOut, 
                    MEM_R_ENIn, MEM_R_ENOut, MEM_W_ENIn, MEM_W_ENOut,
                    EXE_CMDIn, EXE_CMDOut, BIn, BOut, SIn, SOut, 
                    Val_RmIn, Val_RmOut, Val_RnIn, Val_RnOut,
                    shiftOperandIn, shiftOperandOut, IIn, IOut,
                    Imm24In, Imm24Out, DestIn, DestOut, statusIn, statusOut,
                    src1In, src1Out, src2In, src2Out);
    parameter N = 32;

    input wire[0:0] clk, rst, en, clr;
    
    input wire[0:0] WB_ENIn, MEM_R_ENIn, MEM_W_ENIn, BIn, SIn, IIn;
    output reg[0:0] WB_ENOut,MEM_R_ENOut,MEM_W_ENOut,BOut,SOut,IOut;

    input wire[3:0] EXE_CMDIn, DestIn, statusIn, src1In, src2In;
    output reg[3:0] EXE_CMDOut,DestOut, statusOut, src1Out, src2Out;

    input wire[11:0] shiftOperandIn;
    output reg[11:0] shiftOperandOut;

    input wire[23:0] Imm24In;
    output reg[23:0] Imm24Out;

    input wire[31:0] PCIn, Val_RmIn, Val_RnIn;
    output reg[31:0] PCOut,Val_RmOut,Val_RnOut;


    always@(posedge clk or posedge rst) begin

        if (rst) begin
            WB_ENOut        <= 1'b0;
            MEM_R_ENOut     <= 1'b0;
            MEM_W_ENOut     <= 1'b0;
            BOut            <= 1'b0;
            SOut            <= 1'b0;
            IOut            <= 1'b0;
            src1Out         <= 4'b0;
            src2Out         <= 4'b0;
            EXE_CMDOut      <= 4'b0;
            DestOut         <= 4'b0;
            statusOut       <= 4'b0;
            shiftOperandOut <= 12'b0;
            Imm24Out        <= 24'b0;
            PCOut           <= 32'b0;
            Val_RmOut       <= 32'b0;
            Val_RnOut       <= 32'b0;
        end 
        
        else if (clr) begin
            WB_ENOut        <= 1'b0;
            MEM_R_ENOut     <= 1'b0;
            MEM_W_ENOut     <= 1'b0;
            BOut            <= 1'b0;
            SOut            <= 1'b0;
            IOut            <= 1'b0;
            src1Out         <= 4'b0;
            src2Out         <= 4'b0;
            EXE_CMDOut      <= 4'b0;
            DestOut         <= 4'b0;
            statusOut       <= 4'b0;
            shiftOperandOut <= 12'b0;
            Imm24Out        <= 24'b0;
            PCOut           <= 32'b0;
            Val_RmOut       <= 32'b0;
            Val_RnOut       <= 32'b0;
        end

        else if (en) begin
            WB_ENOut        <= WB_ENIn;
            MEM_R_ENOut     <= MEM_R_ENIn;
            MEM_W_ENOut     <= MEM_W_ENIn;
            BOut            <= BIn;
            SOut            <= SIn;
            IOut            <= IIn;
            EXE_CMDOut      <= EXE_CMDIn;
            DestOut         <= DestIn;
            statusOut       <= statusIn;
            shiftOperandOut <= shiftOperandIn;
            Imm24Out        <= Imm24In;
            PCOut           <= PCIn;
            Val_RmOut       <= Val_RmIn;
            Val_RnOut       <= Val_RnIn;
            src1Out         <= src1In;
            src2Out         <= src2In;
        end
    end
endmodule