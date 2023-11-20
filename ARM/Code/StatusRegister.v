
module StatusRegister(clk, rst, en, statIn, statOut);

    input wire[0:0] clk, rst, en;
    input wire[3:0] statIn;

    output reg[3:0] statOut;


    always@(negedge clk or posedge rst) begin

        if(rst) begin
            statOut <= 4'b0;
        end

        if(en) begin
            statOut <= statIn;
        end

    end

endmodule