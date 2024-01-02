module FreqDiv #(
    parameter Bits = 1
)(
    input clk, rst, en,
    output co
);
    reg [Bits-1:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= {Bits{1'b0}};
        else if (en) begin
            if (co)
                q <= {Bits{1'b0}};
            else
                q <= q + 1;
        end
    end

    assign co = &q;
endmodule
