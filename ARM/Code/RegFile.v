`define BITS(x) $rtoi($ceil($clog2(x)))

module RegisterFile(clk, rst, regWrite,
                    readRegister1, readRegister2,
                    writeRegister, writeData,
                    readData1, readData2);
                    
    parameter WordLen = 32;
    parameter WordCount = 16;

    input regWrite, clk, rst;
    input [`BITS(WordCount)-1:0] readRegister1, readRegister2, writeRegister;
    input [WordLen-1:0] writeData;
    
    output [WordLen-1:0] readData1, readData2;

    reg [WordLen-1:0] registerFile [0:WordCount-1];

    integer i;

    always @(negedge clk) begin
        if (rst)
            for (i = 0; i < WordCount; i = i + 1)
                registerFile[i] <= 0;
        if (regWrite & (|writeRegister))
            registerFile[writeRegister] <= writeData;
    end

    assign readData1 = registerFile[readRegister1];
    assign readData2 = registerFile[readRegister2];

endmodule
