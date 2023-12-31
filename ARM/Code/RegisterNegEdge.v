module RegisterNegEdge(in, clk, en, rst, out);
    parameter N = 32;

    input [N-1:0] in;
    input clk, rst, en;

    output reg [N-1:0] out;
    
    always @(negedge clk or posedge rst) begin
        if (rst)
            out <= {N{1'b0}};
        else if (en)
            out <= in;    
    end

endmodule