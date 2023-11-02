module IF_Stage_Reg(clk, rst, en, clr, instrIn, PCIn, instrOut, PCOut);
    
    input wire[0:0] clk, rst, en, clr;
    
    input wire [31:0] instrIn, PCIn;
    output reg [31:0] instrOut, PCOut;
    
    always @(posedge clk or posedge rst) begin
        
        if (rst) begin
            instrOut   <= 32'b0;
            PCOut      <= 32'b0;
        end 
        
        else if (clr) begin
			instrOut   <= 32'b0;
            PCOut      <= 32'b0;
        end

        else if (en) begin
            instrOut   <= instrIn;
            PCOut      <= PCIn;
        end
        
    end

endmodule