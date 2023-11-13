
module MEM_Stage(clk, rst, ALU_ResIn, MEM_W_ENIn, MEM_R_ENIn, WB_ENIn, 
                 Value_RmIn, DestIn, WB_ENOut, MEM_R_ENOut, ALU_ResOut, 
                 DataMemoryOut, DestOut);

    parameter N = 32;
    input wire[0:0] clk, rst;
    
    input wire[0:0] MEM_R_ENIn, MEM_W_ENIn, WB_ENIn;
    input wire[3:0] DestIn;
    input wire[N - 1:0] ALU_ResIn, Value_RmIn;


    output wire[0:0] MEM_R_ENOut, MEM_W_ENOut, WB_ENOut;
    input wire[3:0] DestOut;
    input wire[N - 1:0] DataMemoryOut;


    DataMemory DM(.clk(clk), .rst(rst), .ALU_ResIn(ALU_ResIn), .Value_RmIn(Val_RmIn), .MEM_W_ENIn(MEM_W_ENIn), .MEM_R_ENIn(MEM_R_ENIn), .resultOut(DataMemoryOut));

    assign MEM_R_ENOut = MEM_R_ENIn;
    assign WB_ENOut = WB_ENIn;
    assign DestOut = DestIn;
    

endmodule