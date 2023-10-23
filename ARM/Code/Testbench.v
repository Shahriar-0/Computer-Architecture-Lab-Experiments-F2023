`timescale 1ns/1ns

module Testbench();
    reg clk, rst;
    CPU cpu(.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    initial begin
        rst = 0;
        clk = 0;
        #30 rst = 1;
        #30 rst = 0;
        #2000 $stop;
    end

endmodule