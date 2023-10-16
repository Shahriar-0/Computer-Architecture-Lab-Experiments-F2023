module Mux2to1(a, b, s, out);
    input[31:0] a, b;
    input[0:0] s;

    output[31:0] out;

    assign out = ~s? a : b;
endmodule