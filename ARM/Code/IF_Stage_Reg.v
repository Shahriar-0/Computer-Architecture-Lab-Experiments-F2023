module IF_Stage_Reg(clk, rst, en, clr, instrF, PCF, instrD, PCD);
    
    input clk, rst, clr, en;
    input [31:0] instrF, PCF;

    output reg [31:0] instrD, PCD;
    
    always @(posedge clk or posedge rst) begin
        
        if (rst) begin
            instrD   <= 32'b0;
            PCD      <= 32'b0;
        end 
		  else if (clr) begin
				instrD   <= 32'b0;
            PCD      <= 32'b0;
		  end
        else if (en) begin
            instrD   <= instrF;
            PCD      <= PCF;
        end
        
    end

endmodule