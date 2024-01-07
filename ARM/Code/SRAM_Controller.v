`define IDLE         6'd0
`define DATA_LOW     6'd1
`define DATA_HIGH    6'd2
`define DATA_UP_LOW  6'd3
`define DATA_UP_HIGH 6'd4
`define DONE         6'd5

module SramController(clk, rst, wrEnIn, rdEnIn, addressIn, 
                      writeDataIn, readDataOut, readyOut, 
                      SRAM_DQInOut, SRAM_ADDROut, SRAM_UB_NOut, 
                      SRAM_LB_NOut, SRAM_WE_NOut, SRAM_CE_NOut, SRAM_OE_NOut);
    input clk, rst;
    input wrEnIn, rdEnIn;
    input [31:0] addressIn;
    input [31:0] writeDataIn;
    output reg [63:0] readDataOut;

    output reg readyOut;            // to freeze other stages
    inout [15:0] SRAM_DQInOut;      // SRAM Data bus 16 bits
    output reg [17:0] SRAM_ADDROut; // SRAM Address bus 18 bits
    output SRAM_UB_NOut;            // SRAM High-byte data mask
    output SRAM_LB_NOut;            // SRAM Low-byte data mask
    output reg SRAM_WE_NOut;        // SRAM Write enable
    output SRAM_CE_NOut;            // SRAM Chip enable
    output SRAM_OE_NOut;            // SRAM Output enable

    assign {SRAM_UB_NOut, SRAM_LB_NOut, SRAM_CE_NOut, SRAM_OE_NOut} = 4'b0000;

    wire [31:0] memAddr;
    assign memAddr = addressIn - 32'd1024;

    wire [17:0] sramLowAddr, sramHighAddr, sramUpLowAddess, sramUpHighAddess;
    assign sramLowAddr = {memAddr[18:3], 2'd0};
    assign sramHighAddr = sramLowAddr + 18'd1;
    assign sramUpLowAddess = sramLowAddr + 18'd2;
    assign sramUpHighAddess = sramLowAddr + 18'd3;

    wire [17:0] sramLowAddrWrite, sramHighAddrWrite;
    assign sramLowAddrWrite = {memAddr[18:2], 1'b0};
    assign sramHighAddrWrite = sramLowAddrWrite + 18'd1;

    reg [15:0] dq;
    assign SRAM_DQInOut = wrEnIn ? dq : 16'bz;

    reg [2:0] ps, ns;

    always @(ps or wrEnIn or rdEnIn) begin
        case (ps)
            `IDLE        : ns = (wrEnIn == 1'b1 || rdEnIn == 1'b1) ? `DATA_LOW : `IDLE;
            `DATA_LOW    : ns = `DATA_HIGH;
            `DATA_HIGH   : ns = `DATA_UP_LOW;
            `DATA_UP_LOW : ns = `DATA_UP_HIGH;
            `DATA_UP_HIGH: ns = `DONE;
            `DONE        : ns = `IDLE;
        endcase
    end

    always @(*) begin
        SRAM_ADDROut = 18'b0;
        SRAM_WE_NOut = 1'b1;
        readyOut = 1'b0;

        case (ps)
            `IDLE: readyOut = ~(wrEnIn | rdEnIn);

            `DATA_LOW: begin
                SRAM_WE_NOut = ~wrEnIn;
                if (rdEnIn) begin
                    SRAM_ADDROut = sramLowAddr;
                    readDataOut[15:0] <= SRAM_DQInOut;
                end
                else if (wrEnIn) begin
                    SRAM_ADDROut = sramLowAddrWrite;
                    dq = writeDataIn[15:0];
                end
            end

            `DATA_HIGH: begin
                SRAM_WE_NOut = ~wrEnIn;
                if (rdEnIn) begin
                    SRAM_ADDROut = sramHighAddr;
                    readDataOut[31:16] <= SRAM_DQInOut;
                end
                else if (wrEnIn) begin
                    SRAM_ADDROut = sramHighAddrWrite;
                    dq = writeDataIn[31:16];
                end
            end

            `DATA_UP_LOW: begin
                SRAM_WE_NOut = 1'b1;
                if (rdEnIn) begin
                    SRAM_ADDROut = sramUpLowAddess;
                    readDataOut[47:32] <= SRAM_DQInOut;
                end
            end

            `DATA_UP_HIGH: begin
                SRAM_WE_NOut = 1'b1;
                if (rdEnIn) begin
                    SRAM_ADDROut = sramUpHighAddess;
                    readDataOut[63:48] <= SRAM_DQInOut;
                end
            end
            
            `DONE: readyOut = 1'b1;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) 
            ps <= `IDLE;
        else 
            ps <= ns;
    end
    
endmodule
