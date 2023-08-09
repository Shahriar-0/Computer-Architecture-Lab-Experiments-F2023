module CacheController(
    input clk, rst,
    input rdEn, wrEn,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData,
    output ready,
    // Sram Controller
    input sramReady,
    input [63:0] sramReadData,
    output sramWrEn, sramRdEn
);
    // Cache
    reg [31:0] way0First  [0:63];
    reg [31:0] way0Second [0:63];
    reg [31:0] way1First  [0:63];
    reg [31:0] way1Second [0:63];
    reg [9:0] way0Tag [0:63];
    reg [9:0] way1Tag [0:63];
    reg [63:0] way0Valid;
    reg [63:0] way1Valid;
    reg [63:0] indexLru;

    // Address Decode
    wire [2:0] offset;
    wire [5:0] index;
    wire [9:0] tag;
    assign offset = address[2:0];
    assign index = address[8:3];
    assign tag = address[18:9];

    // Way Decode
    wire [31:0] dataWay0, dataWay1;
    wire [9:0] tagWay0, tagWay1;
    wire validWay0, validWay1;
    assign dataWay0 = (offset[2] == 1'b0) ? way0First[index] : way0Second[index];
    assign dataWay1 = (offset[2] == 1'b0) ? way1First[index] : way1Second[index];
    assign tagWay0 = way0Tag[index];
    assign tagWay1 = way1Tag[index];
    assign validWay0 = way0Valid[index];
    assign validWay1 = way1Valid[index];

    // Hit Controller
    wire hit;
    wire hitWay0, hitWay1;
    assign hitWay0 = (tagWay0 == tag && validWay0 == 1'b1);
    assign hitWay1 = (tagWay1 == tag && validWay1 == 1'b1);
    assign hit = hitWay0 | hitWay1;

    // Data Controller
    wire [31:0] data;
    wire [31:0] readDataQ;
    assign data = hitWay0 ? dataWay0 :
                  hitWay1 ? dataWay1 : 32'dz;
    assign readDataQ = hit ? data :
                       sramReady ? (offset[2] == 1'b0 ? sramReadData[31:0] : sramReadData[63:32]) : 32'bz;
    assign readData = rdEn ? readDataQ : 32'bz;
    assign ready = sramReady;

    // Sram Controller
    assign sramRdEn = ~hit & rdEn;
    assign sramWrEn = wrEn;

    always @(posedge clk) begin
        if (wrEn) begin
            if (hitWay0) begin
                way0Valid[index] = 1'b0;
                indexLru[index] = 1'b1;
            end
            else if (hitWay1) begin
                way1Valid[index] = 1'b0;
                indexLru[index] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (rdEn) begin
            if (hit) begin
                // readData = data;
                indexLru[index] = hitWay1;
            end
            else begin
                if (sramReady) begin
                    if (indexLru[index] == 1'b1) begin
                        {way0Second[index], way0First[index]} = sramReadData;
                        way0Valid[index] = 1'b1;
                        way0Tag[index] = tag;
                        indexLru[index] = 1'b0;
                    end
                    else begin
                        {way1Second[index], way1First[index]} = sramReadData;
                        way1Valid[index] = 1'b1;
                        way1Tag[index] = tag;
                        indexLru[index] = 1'b1;
                    end
                    // readData = (offset[2] == 1'b0) ? sramReadData[31:0] : sramReadData[63:32];
                end
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            way0Valid = 64'd0;
            way1Valid = 64'd0;
            indexLru = 64'd0;
        end
    end
endmodule
