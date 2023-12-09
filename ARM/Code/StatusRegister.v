
module StatusRegister(clk, rst, en, statIn, statOut);

    input wire[0:0] clk, rst, en;
    input wire[3:0] statIn;

    output reg[3:0] statOut;


    always@(negedge clk or posedge rst) begin
        if(rst) 
            statOut <= 4'b0;
        else if(en) 
            statOut <= statIn;
    end

endmodule