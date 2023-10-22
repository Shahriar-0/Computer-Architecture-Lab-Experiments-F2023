module InstructionMemory(pc, instruction);
    parameter Count = 1024;

    input [31:0] pc;

    output reg [31:0] instruction;

    reg [7:0] instructionMemory [0:$pow(2, 16)-1]; 

    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; 

    always @(adr) begin
        case (adr)
            32'd0: instruction = 32'b0000_00_0_0000_0_0000_0000_000000000000;
        endcase
    end

endmodule