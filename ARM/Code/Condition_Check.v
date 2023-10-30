module ConditionCheck(condIn, condOut, statusIn);
    input [3:0] condIn;
    input [3:0] statusIn;
    output reg consOut;

    wire n, z, c, v;
    assign {n, z, c, v} = statusIn;

    always @(condIn, n, z, c, v) begin
        consOut = 1'b0;
        case (condIn)
            4'b0000: consOut = z;             // EQ
            4'b0001: consOut = ~z;            // NE
            4'b0010: consOut = c;             // CS/HS
            4'b0011: consOut = ~c;            // CC/LO
            4'b0100: consOut = n;             // MI
            4'b0101: consOut = ~n;            // PL
            4'b0110: consOut = v;             // VS
            4'b0111: consOut = ~v;            // VC
            4'b1000: consOut = c & ~z;        // HI
            4'b1001: consOut = ~c | z;        // LS
            4'b1010: consOut = (n == v);      // GE
            4'b1011: consOut = (n != v);      // LT
            4'b1100: consOut = ~z & (n == v); // GT
            4'b1101: consOut = z | (n != v);  // LE
            4'b1110: consOut = 1'b1;          // AL
            default: consOut = 1'bx;
        endcase
    end
endmodule
