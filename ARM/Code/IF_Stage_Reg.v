module IF_Stage_Reg(clk, rst, en, clr, instrF, PCF, instrD, PCD);
    
    input clk, rst, clr, en;
    input [31:0] instrF, PCF, PCPlus4F;

    output reg [31:0] instrD, PCD, PCPlus4D;
    
    always @(posedge clk or negedge rst) begin
        
        if (rst || clr) begin
            instrD   <= 32'b0;
            PCD      <= 32'b0;
            PCPlus4D <= 3'b0;
        end 

        else if (en) begin
            instrD   <= instrF;
            PCD      <= PCF;
            PCPlus4D <= PCPlus4F;
        end
        
    end

endmodulea