module RegisterFile(clk, rst, regWrite, regRead,
                    readRegister1, readRegister2,
                    writeRegister, writeData,
                    readData1, readData2);
                    
    parameter WORD_LEN = 32;
    parameter WORD_COUNT = 16;

    input clk, rst, regWrite, regRead;
    input [3:0] readRegister1, readRegister2, writeRegister;
    input [WORD_LEN-1:0] writeData;
    
    output [WORD_LEN-1:0] readData1, readData2;

    reg [WORD_LEN-1:0] registerFile [0:WORD_COUNT-1];

    integer i;

    initial begin
        for (i = 0; i < WORD_COUNT; i = i + 1)
            registerFile[i] <= i;
    end

    always @(negedge clk) begin
        if (rst)
            for (i = 0; i < WORD_COUNT; i = i + 1)
                registerFile[i] <= i;
        if (regWrite)
            registerFile[writeRegister] <= writeData;
    end

    assign readData1 = (regRead)? registerFile[readRegister1] : {WORD_LEN{1'bz}};
    assign readData2 = (regRead)? registerFile[readRegister2] : {WORD_LEN{1'bz}};
endmodule
