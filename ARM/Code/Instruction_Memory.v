module Instruction_Memory(pc, instruction);
    parameter Count = 1024;

    input [31:0] pc;

    output reg [31:0] instruction;

    reg [7:0] instructionMemory [0:$pow(2, 16)-1]; 

    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; 

    always @(adr) begin
        case (adr)
            32'd0 : instruction = 32'b000000_00001_00010_00000_00000000000; 
            32'd4 : instruction = 32'b000000_00011_00100_00000_00000000000; 
            32'd8 : instruction = 32'b000000_00101_00110_00000_00000000000; 
            32'd12: instruction = 32'b000000_00111_01000_00010_00000000000; 
            32'd16: instruction = 32'b000000_01001_01010_00011_00000000000; 
            32'd20: instruction = 32'b000000_01011_01100_00000_00000000000; 
            32'd24: instruction = 32'b000000_01101_01110_00000_00000000000;
        endcase
    end

endmodule