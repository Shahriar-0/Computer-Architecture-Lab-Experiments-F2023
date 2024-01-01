module CacheController(clk, rst, rdEnIn, wrEnIn, adrIn, wDataIn, 
                       rDataOut, readyOut, sramReadyIn, sramReadDataIn, 
                       sramWrEnOut, sramRdEnOut);

    input clk, rst, rdEnIn, wrEnIn, sramReadyIn;
    input [31:0] adrIn;
    input [31:0] wDataIn;
    input [63:0] sramReadDataIn;
    output sramWrEnOut, sramRdEnOut, readyOut;
    output [31:0] rDataOut;

    // ------------------ Address Decode ------------------
    wire [2:0] offset;
    wire [5:0] index;
    wire [9:0] tag;

    assign offset = adrIn[2:0];
    assign index = adrIn[8:3];
    assign tag = adrIn[18:9];
    // ----------------------------------------------------


    // ------------------ Way Decode ------------------
    reg [31:0] way0F      [0:63];
    reg [31:0] way0S      [0:63];
    reg [31:0] way1F      [0:63];
    reg [31:0] way1S      [0:63];
    reg [9:0]  way0Tag    [0:63];
    reg [9:0]  way1Tag    [0:63];
    
    reg [63:0] indexLRU;
    wire [31:0] dataWay0, dataWay1;
    wire [9:0] tagWay0, tagWay1;
    wire validWay0, validWay1;

    assign dataWay0  = (offset[2] == 1'b0) ? way0F[index] : way0S[index];
    assign dataWay1  = (offset[2] == 1'b0) ? way1F[index] : way1S[index];
    assign tagWay0   = way0Tag[index];
    assign tagWay1   = way1Tag[index];
    // ------------------------------------------------

    // ------------------ Valid Decode ----------------
    reg [63:0] way0Valid;
    reg [63:0] way1Valid;
    assign validWay0 = way0Valid[index];
    assign validWay1 = way1Valid[index];
    // ------------------------------------------------


    // ------------------ Hit Controller ------------------
    wire hit;
    wire hitWay0, hitWay1;

    assign hitWay0 = (tagWay0 == tag && validWay0 == 1'b1);
    assign hitWay1 = (tagWay1 == tag && validWay1 == 1'b1);
    assign hit = hitWay0 | hitWay1;
    // ----------------------------------------------------

    // ------------------ Data Controller ------------------
    wire [31:0] data;
    wire [31:0] readDataQ;

    assign data = hitWay0 ? dataWay0 :
                  hitWay1 ? dataWay1 : 32'bz;
    
    assign readDataQ = hit         ? data :
                       sramReadyIn ? (offset[2] == 1'b0 ? sramReadDataIn[31:0]   : 
                                                          sramReadDataIn[63:32]) : 32'bz;

    assign rDataOut = (rdEnIn == 1'b1) ? readDataQ : 32'bz;
    assign readyOut = sramReadyIn;
    // ----------------------------------------------------

    // ------------------ Sram Controller ------------------
    assign sramRdEnOut = ~hit & rdEnIn;
    assign sramWrEnOut = wrEnIn;
    // -----------------------------------------------------

    always @(posedge clk) begin
        
    end

    always @(posedge clk) begin
        
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            way0Valid <= 64'd0;
            way1Valid <= 64'd0;
            indexLRU <= 64'd0;
        end

        else begin
            if (rdEnIn) begin
                if (hit) 
                    indexLRU[index] = hitWay1;
                else begin
                    if (sramReadyIn) begin
                        if (indexLRU[index] == 1'b1) begin
                            indexLRU[index] <= 1'b0;
                            {way0S[index], way0F[index]} <= sramReadDataIn;
                            way0Valid[index] <= 1'b1;
                            way0Tag[index] <= tag;
                        end
                        else begin
                            indexLRU[index] <= 1'b1;
                            {way1S[index], way1F[index]} <= sramReadDataIn;
                            way1Valid[index] <= 1'b1;
                            way1Tag[index] <= tag;
                        end
                    end
                end
            end

            if (wrEnIn) begin
                if (hitWay0) begin
                    indexLRU[index] <= 1'b1;
                    way0Valid[index] <= 1'b0;
                end
                else if (hitWay1) begin
                    indexLRU[index] <= 1'b0;
                    way1Valid[index] <= 1'b0;
                end
            end
        end
    end

endmodule
