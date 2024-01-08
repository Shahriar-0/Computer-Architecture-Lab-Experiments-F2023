module Mux2to1(a, b, s, out);
    parameter N = 32;
    
    input[N - 1:0] a, b;
    input[0:0] s;

    output[N - 1:0] out;

    assign out = ~s? a : b;
endmodule