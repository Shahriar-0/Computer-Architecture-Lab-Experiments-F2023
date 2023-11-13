module HazardUnit(RnIn, reg2In, Two_srcIn, EXE_DestIn, MEM_DestIn, EXE_WB_ENIn, 
                  MEM_WB_ENIn, MEM_R_ENIn, forwardENIn, HazardOut);
    input wire[3:0] RnIn, reg2In;
    input wire[0:0] Two_srcIn;
    input wire[3:0] EXE_DestIn, MEM_DestIn;
    input wire[0:0] EXE_WB_ENIn, MEM_WB_ENIn, MEM_R_ENIn;
    input wire[0:0] forwardENIn;
    output reg HazardOut;

    always @(RnIn, reg2In, EXE_DestIn, MEM_DestIn, 
            EXE_WB_ENIn, MEM_WB_ENIn, MEM_R_ENIn, Two_srcIn, forwardENIn) begin
        HazardOut = 1'b0;
        if (forwardENIn) begin
            if (MEM_R_ENIn) begin
                if (RnIn == EXE_DestIn || (Two_srcIn && reg2In == EXE_DestIn)) begin
                    HazardOut = 1'b1;
                end
            end
        end
        
        else begin
            if (EXE_WB_ENIn) begin
                if (RnIn == EXE_DestIn || (Two_srcIn && reg2In == EXE_DestIn)) begin
                    HazardOut = 1'b1;
                end
            end
            if (MEM_WB_ENIn) begin
                if (RnIn == MEM_DestIn || (Two_srcIn && reg2In == MEM_DestIn)) begin
                    HazardOut = 1'b1;
                end
            end
        end
    end
endmodule
