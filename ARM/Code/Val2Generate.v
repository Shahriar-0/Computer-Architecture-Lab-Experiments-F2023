module Val2Generate(valRmIn, shiftOperandIn, IIn, STypeSignal, valOut);

    input wire[0:0] IIn, STypeSignal;
    input wire[11:0] shiftOperandIn;
    input wire[31:0] valRmIn;

    output reg[31:0] valOut;

    wire[4:0] shift_imm = shiftOperandIn[11:7];
    wire[1:0] shift = shiftOperandIn[6:5];

    wire[7:0] immed_8 = shiftOperandIn[7:0];
    wire[3:0] rotate_imm = shiftOperandIn[11:8];

    integer i;

    always @(valRmIn, shiftOperandIn, IIn, STypeSignal) begin
        valOut = 32'b0;
        // -------------------------- LDR SDR ---------------------------
        if (STypeSignal) begin  
            valOut = {{20{shiftOperandIn[11]}}, shiftOperandIn};
        end


        // ---------------------- 32-bit Immediate ----------------------
        else if (IIn) begin // 
            valOut = {24'b0, immed_8};
            for (i = 0; i < 2 * rotate_imm; i = i + 1) begin
                valOut = {valOut[0], valOut[31:1]};
            end

        end

        // ---------------------- Immediate Shifts -----------------------
        else begin 
            case (shift)
                    2'b00: valOut = valRmIn << shift_imm;           // LSL
                    2'b01: valOut = valRmIn >> shift_imm;           // LSR
                    2'b10: valOut = $signed(valRmIn) >>> shift_imm; // ASR
                    2'b11: begin                                    // ROR
                        valOut = valRmIn;
                        for (i = 0; i < shift_imm; i = i + 1) begin
                            valOut = {valOut[0], valOut[31:1]};
                        end
                    end
            endcase

        end            
    end

endmodule