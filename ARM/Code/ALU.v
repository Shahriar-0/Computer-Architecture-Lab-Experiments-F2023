module ALU(Val1In, Val2In, EXE_CMDIn, statusCarryIn, statusOut, ALU_ResOut);
    parameter N = 32;

    input [N-1:0] Val1In, Val2In;
    input statusCarryIn;
    input [3:0] EXE_CMDIn;
    
    output reg [N-1:0] ALU_ResOut;
    output [3:0] statusOut;

    reg c, v;
    wire z, n;
    assign statusOut = {n, z, c, v};
    assign z = ~|ALU_ResOut;
    assign n = ALU_ResOut[N-1];

    wire [N-1:0] statusCarryInExt, notStatusCarryInExt;
    assign statusCarryInExt = {{(N-1){1'b0}}, statusCarryIn};
    assign notStatusCarryInExt = {{(N-1){1'b0}}, ~statusCarryIn};

    always @(EXE_CMDIn or Val1In or Val2In or statusCarryInExt or notStatusCarryInExt) begin
        ALU_ResOut = {N{1'b0}};
        c = 1'b0;

        case (EXE_CMDIn)
            4'b0001: ALU_ResOut = Val2In;                                // MOV
            4'b1001: ALU_ResOut = ~Val2In;                               // MVN
            4'b0010: {c, ALU_ResOut} = Val1In + Val2In;                       // ADD
            4'b0011: {c, ALU_ResOut} = Val1In + Val2In + statusCarryInExt;    // ADC
            4'b0100: {c, ALU_ResOut} = Val1In - Val2In;                       // SUB
            4'b0101: {c, ALU_ResOut} = Val1In - Val2In - notStatusCarryInExt; // SBC
            4'b0110: ALU_ResOut = Val1In & Val2In;                            // AND
            4'b0111: ALU_ResOut = Val1In | Val2In;                            // ORR
            4'b1000: ALU_ResOut = Val1In ^ Val2In;                            // EOR
            default: ALU_ResOut = {N{1'b0}};
        endcase

        v = 1'b0;
        if (EXE_CMDIn[3:1] == 3'b001) begin      // ADD, ADC
            v = (Val1In[N-1] == Val2In[N-1]) && (Val1In[N-1] != ALU_ResOut[N-1]);
        end
        else if (EXE_CMDIn[3:1] == 3'b010) begin // SUB, SBC
            v = (Val1In[N-1] != Val2In[N-1]) && (Val1In[N-1] != ALU_ResOut[N-1]);
        end

    end
endmodule
