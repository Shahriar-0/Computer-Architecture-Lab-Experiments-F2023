module ForwardingUnit(forwardEnIn, src1In, src2In, 
                      MEM_MEMR_WB_ENIn, WB_ID_WB_ENIn, 
                      MEM_MEMR_DestIn, WB_ID_DestIn, 
                      selSrc1Out, selSrc2Out);
    input forwardEnIn;
    input [3:0] src1In, src2In;
    input MEM_MEMR_WB_ENIn, WB_ID_WB_ENIn;
    input [3:0] MEM_MEMR_DestIn, WB_ID_DestIn;
    output reg [1:0] selSrc1Out, selSrc2Out;

    always @(*) begin
        selSrc1Out = 2'b00;
        if (forwardEnIn) begin
            if (MEM_MEMR_WB_ENIn && (MEM_MEMR_DestIn == src1In)) 
                selSrc1Out = 2'b01;
            else if (WB_ID_WB_ENIn && (WB_ID_DestIn == src1In)) 
                selSrc1Out = 2'b10;
        end
    end

    always @(*) begin
        selSrc2Out = 2'b00;
        if (forwardEnIn) begin
            if (MEM_MEMR_WB_ENIn && (MEM_MEMR_DestIn == src2In))
                selSrc2Out = 2'b01;
            else if (WB_ID_WB_ENIn && (WB_ID_DestIn == src2In))
                selSrc2Out = 2'b10;
        end
    end

endmodule
