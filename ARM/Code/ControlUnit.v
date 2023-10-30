module ControlUnit(modeIn, opCodeIn, SIn, EXE_CMDOut, SOut, BOut, 
                   MEM_W_ENOut, MEM_R_ENOut, WB_ENOut); 

    input [1:0] modeIn;
    input [3:0] opCodeIn;
    input SIn;

    output reg [3:0] EXE_CMDOut;
    output reg MEM_R_ENOut, MEM_W_ENOut;
    output reg WB_ENOut, BOut, SOut;

    always @(mode, opCodeIn, sIn) begin
        EXE_CMDOut = 4'd0;
        {MEM_R_ENOut, MEM_W_ENOut} = 2'd0;
        {WB_ENOut, BOut, SOut} = 3'd0;

        case (opCodeIn)
            4'b1101: EXE_CMDOut = 4'b0001; // MOV
            4'b1111: EXE_CMDOut = 4'b1001; // MVN
            4'b0100: EXE_CMDOut = 4'b0010; // ADD, LDR, STR
            4'b0101: EXE_CMDOut = 4'b0011; // ADC
            4'b0010: EXE_CMDOut = 4'b0100; // SUB
            4'b0110: EXE_CMDOut = 4'b0101; // SBC
            4'b0000: EXE_CMDOut = 4'b0110; // AND
            4'b1100: EXE_CMDOut = 4'b0111; // ORR
            4'b0001: EXE_CMDOut = 4'b1000; // EOR
            4'b1010: EXE_CMDOut = 4'b0100; // CMP
            4'b1000: EXE_CMDOut = 4'b0110; // TST
            default: EXE_CMDOut = 4'b0001;
        endcase

        case (mode)
            2'b00: begin
                SOut = SIn;
                // no write-back for CMP and TST
                WB_ENOut = (opCodeIn == 4'b1010 || opCodeIn == 4'b1000) ? 1'b0 : 1'b1;
            end

            2'b01: begin
                WB_ENOut = SIn;
                MEM_R_ENOut = SIn;
                MEM_W_ENOut = ~sIn;
            end

            2'b10: 
                BOut = 1'b1;
            
        endcase
    end
endmodule
