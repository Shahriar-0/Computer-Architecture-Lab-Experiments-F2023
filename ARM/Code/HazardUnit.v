module HazardUnit(Src1In, Src2In, TwoSrcIn, EXE_DestIn, MEM_DestIn, EXE_WB_ENIn, 
                  MEM_WB_ENIn, MEM_R_ENIn, forwardENIn, HazardOut);

    input wire[3:0] Src1In, Src2In;
    input wire[0:0] TwoSrcIn;
    input wire[3:0] EXE_DestIn, MEM_DestIn;
    input wire[0:0] EXE_WB_ENIn, MEM_WB_ENIn, MEM_R_ENIn;
    input wire[0:0] forwardENIn;
    output reg HazardOut;

    always @(*) begin
        HazardOut = 1'b0;
        if (forwardENIn) begin
            if (MEM_R_ENIn) begin
                if (Src1In == EXE_DestIn || (TwoSrcIn && Src2In == EXE_DestIn)) begin
                    HazardOut = 1'b1;
                end
            end
        end
        
        else begin
            if (EXE_WB_ENIn) begin
                if (Src1In == EXE_DestIn || (TwoSrcIn && Src2In == EXE_DestIn)) begin
                    HazardOut = 1'b1;
                end
            end
            if (MEM_WB_ENIn) begin
                if (Src1In == MEM_DestIn || (TwoSrcIn && Src2In == MEM_DestIn)) begin
                    HazardOut = 1'b1;
                end
            end
        end
    end
endmodule
