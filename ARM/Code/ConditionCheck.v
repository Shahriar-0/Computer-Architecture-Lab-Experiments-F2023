module ConditionCheck(condIn, condOut, statusIn);

    input [3:0] condIn;
    input [3:0] statusIn;

    output reg condOut;

    wire n, z, c, v;
    assign {n, z, c, v} = statusIn;

    always @(condIn, n, z, c, v) begin
        condOut = 1'b0;
        case (condIn)
            4'b0000: condOut = z;             // EQ
            4'b0001: condOut = ~z;            // NE
            4'b0010: condOut = c;             // CS/HS
            4'b0011: condOut = ~c;            // CC/LO
            4'b0100: condOut = n;             // MI
            4'b0101: condOut = ~n;            // PL
            4'b0110: condOut = v;             // VS
            4'b0111: condOut = ~v;            // VC
            4'b1000: condOut = c & ~z;        // HI
            4'b1001: condOut = ~c | z;        // LS
            4'b1010: condOut = (n == v);      // GE
            4'b1011: condOut = (n != v);      // LT
            4'b1100: condOut = ~z & (n == v); // GT
            4'b1101: condOut = z | (n != v);  // LE
            4'b1110: condOut = 1'b1;          // AL
            default: condOut = 1'bx;
        endcase
    end
    
endmodule
