
module MEM_Stage_Reg(clk, rst, clr, en, WB_ENIn, WB_ENOut, MEM_R_ENIn, 
                    MEM_R_ENOut, ALU_ResIn, ALU_ResOut, DataMemoryIn, 
                    DataMemoryOut, DestIn, DestOut);

    parameter N = 32;
    input wire[0:0] clk, rst, clr, en;

    input wire[0:0] WB_ENIn, MEM_R_ENIn;
    input wire[3:0] DestIn;
    input wire[N - 1:0] ALU_ResIn, DataMemoryIn;
    
    output reg[0:0] WB_ENOut, MEM_R_ENOut;
    output reg[3:0] DestOut;
    output reg[N - 1:0] ALU_ResOut, DataMemoryOut;


    always@(posedge clk or posedge rst) begin

        if (rst) begin
            WB_ENOut        <= 1'b0;
            MEM_R_ENOut     <= 1'b0;
            DestOut         <= 4'b0;
            ALU_ResOut      <= 32'b0;
            DataMemoryOut   <= 32'b0;
        end 
        
        else if (clr) begin
            WB_ENOut        <= 1'b0;
            MEM_R_ENOut     <= 1'b0;
            DestOut         <= 4'b0;
            ALU_ResOut      <= 32'b0;
            DataMemoryOut   <= 32'b0;    
        end

        else if (en) begin
            WB_ENOut        <= WB_ENIn;
            MEM_R_ENOut     <= MEM_R_ENIn;
            DestOut         <= DestIn;
            ALU_ResOut      <= ALU_ResIn;
            DataMemoryOut   <= DataMemoryIn;  
        end

    end

endmodule