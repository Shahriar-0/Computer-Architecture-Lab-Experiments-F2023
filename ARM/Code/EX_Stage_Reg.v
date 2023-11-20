
module EXE_Stage_Reg(clk, rst, en, clr, WB_ENIn, WB_ENOut, 
                     MEM_R_ENIn, MEM_R_ENOut, MEM_W_ENIn, MEM_W_ENOut, 
                     ALU_ResIn, ALU_ResOut, Val_RmIn, Val_RmOut, DestIn, DestOut);

    input wire[0:0] clk, rst, en, clr;
    
    input wire[0:0] WB_ENIn, MEM_R_ENIn, MEM_W_ENIn;
    output reg[0:0] WB_ENOut, MEM_R_ENOut, MEM_W_ENOut;
    
    input wire[3:0] DestIn;
    output reg[3:0] DestOut;

    input wire[31:0] ALU_ResIn, Val_RmIn;
    output reg[31:0] ALU_ResOut, Val_RmOut;

    always@(posedge clk or posedge rst) begin

        if (rst) begin
            WB_ENOut        <= 1'b0;
            MEM_R_ENOut     <= 1'b0;
            MEM_W_ENOut     <= 1'b0;
            DestOut         <= 4'b0;
            Val_RmOut       <= 32'b0;
            ALU_ResOut      <= 32'b0;
        end 
        
        else if (clr) begin
            WB_ENOut        <= 1'b0;
            MEM_R_ENOut     <= 1'b0;
            MEM_W_ENOut     <= 1'b0;
            DestOut         <= 4'b0;
            Val_RmOut       <= 32'b0;
            ALU_ResOut      <= 32'b0;
        end

        else if (en) begin
            WB_ENOut        <= WB_ENIn;
            MEM_R_ENOut     <= MEM_R_ENIn;
            MEM_W_ENOut     <= MEM_W_ENIn;
            DestOut         <= DestIn;
            Val_RmOut       <= Val_RmIn;
            ALU_ResOut      <= ALU_ResIn;
        end
    end
endmodule
