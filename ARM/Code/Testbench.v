module Testbench();
    reg clk, rst;
    ARM arm(.CLK_50(clk), .SW({17{0}, rst}));

    always #5 clk = ~clk;

    initial begin
        rst = 0;
        #30 rst = 1;
        #30 rst = 0;
    end

endmodule