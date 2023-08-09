module arm(
    // Clock Input
    input CLOCK_27,          // 27 MHz
    input CLOCK_50,          // 50 MHz
    input EXT_CLOCK,         // External Clock
    // Push Button
    input [3:0] KEY,         // Pushbutton
    // DPDT Switch
    input [17:0] SW,         // Toggle Switch
    // 7-SEG Display
    output [6:0] HEX0,       // Seven Segment Digit 0
    output [6:0] HEX1,       // Seven Segment Digit 1
    output [6:0] HEX2,       // Seven Segment Digit 2
    output [6:0] HEX3,       // Seven Segment Digit 3
    output [6:0] HEX4,       // Seven Segment Digit 4
    output [6:0] HEX5,       // Seven Segment Digit 5
    output [6:0] HEX6,       // Seven Segment Digit 6
    output [6:0] HEX7,       // Seven Segment Digit 7
    // LED
    output [8:0] LEDG,       // LED Green
    output [17:0] LEDR,      // LED Red
    // UART
    //output UART_TXD,       // UART Transmitter
    //input UART_RXD,        // UART Receiver
    // IRDA
    //output IRDA_TXD,       // IRDA Transmitter
    //input IRDA_RXD,        // IRDA Receiver
    // SDRAM Interface
    inout [15:0] DRAM_DQ,    // SDRAM Data Bus
    output [11:0] DRAM_ADDR, // SDRAM Address Bus
    output DRAM_LDQM,        // SDRAM Low-byte Data Mask
    output DRAM_UDQM,        // SDRAM High-byte Data Mask
    output DRAM_WE_N,        // SDRAM Write Enable
    output DRAM_CAS_N,       // SDRAM Column Address Strobe
    output DRAM_RAS_N,       // SDRAM Row Address Strobe
    output DRAM_CS_N,        // SDRAM Chip Select
    output DRAM_BA_0,        // SDRAM Bank Address 0
    output DRAM_BA_1,        // SDRAM Bank Address 1
    output DRAM_CLK,         // SDRAM Clock
    output DRAM_CKE,         // SDRAM Clock Enable
    // Flash Interface
    inout [7:0] FL_DQ,       // FLASH Data Bus
    output [21:0] FL_ADDR,   // FLASH Address Bus
    output FL_WE_N,          // FLASH Write Enable
    output FL_RST_N,         // FLASH Reset
    output FL_OE_N,          // FLASH Output Enable
    output FL_CE_N,          // FLASH Chip Enable
    // SRAM Interface
    inout [15:0] SRAM_DQ,    // SRAM Data Bus
    output [17:0] SRAM_ADDR, // SRAM Address Bus
    output SRAM_UB_N,        // SRAM High-byte Data Mask
    output SRAM_LB_N,        // SRAM Low-byte Data Mask
    output SRAM_WE_N,        // SRAM Write Enable
    output SRAM_CE_N,        // SRAM Chip Enable
    output SRAM_OE_N,        // SRAM Output Enable
    // ISP1362 Interface
    inout [15:0] OTG_DATA,   // ISP1362 Data Bus
    output [1:0] OTG_ADDR,   // ISP1362 Address
    output OTG_CS_N,         // ISP1362 Chip Select
    output OTG_RD_N,         // ISP1362 Write
    output OTG_WR_N,         // ISP1362 Read
    output OTG_RST_N,        // ISP1362 Reset
    output OTG_FSPEED,       // USB Full Speed: 0 = Enable, Z = Disable
    output OTG_LSPEED,       // USB Low Speed:  0 = Enable, Z = Disable
    input OTG_INT0,          // ISP1362 Interrupt 0
    input OTG_INT1,          // ISP1362 Interrupt 1
    input OTG_DREQ0,         // ISP1362 DMA Request 0
    input OTG_DREQ1,         // ISP1362 DMA Request 1
    output OTG_DACK0_N,      // ISP1362 DMA Acknowledge 0
    output OTG_DACK1_N,      // ISP1362 DMA Acknowledge 1
    // LCD Module 16X2
    inout [7:0] LCD_DATA,    // LCD Data Bus
    output LCD_ON,           // LCD Power ON/OFF
    output LCD_BLON,         // LCD Back Light ON/OFF
    output LCD_RW,           // LCD Read/Write Select: 0 = Write, 1 = Read
    output LCD_EN,           // LCD Enable
    output LCD_RS,           // LCD Command/Data Select: 0 = Command, 1 = Data
    // SD Card Interface
    //inout [3:0] SD_DAT,    // SD Card Data
    //input SD_WP_N,         // SD Write protect
    //inout SD_CMD,          // SD Card Command Signal
    //output SD_CLK,         // SD Card Clock
    // USB JTAG link
    input TDI,               // CPLD -> FPGA (data in)
    input TCK,               // CPLD -> FPGA (clk)
    input TCS,               // CPLD -> FPGA (CS)
    output TDO,              // FPGA -> CPLD (data out)
    // I2C
    inout I2C_SDAT,          // I2C Data
    output I2C_SCLK,         // I2C Clock
    // PS2
    input PS2_DAT,           // PS2 Data
    input PS2_CLK,           // PS2 Clock
    // VGA
    output VGA_CLK,          // VGA Clock
    output VGA_HS,           // VGA H_SYNC
    output VGA_VS,           // VGA V_SYNC
    output VGA_BLANK,        // VGA BLANK
    output VGA_SYNC,         // VGA SYNC
    output [9:0] VGA_R,      // VGA Red
    output [9:0] VGA_G,      // VGA Green
    output [9:0] VGA_B,      // VGA Blue
    // Ethernet Interface
    inout [15:0] ENET_DATA,  // DM9000A Data Bus
    output ENET_CMD,         // DM9000A Command/Data Select: 0 = Command, 1 = Data
    output ENET_CS_N,        // DM9000A Chip Select
    output ENET_WR_N,        // DM9000A Write
    output ENET_RD_N,        // DM9000A Read
    output ENET_RST_N,       // DM9000A Reset
    input ENET_INT,          // DM9000A Interrupt
    output ENET_CLK,         // DM9000A Clock 25 MHz
    // Audio CODEC
    inout AUD_ADCLRCK,       // Audio CODEC ADC LR Clock
    input AUD_ADCDAT,        // Audio CODEC ADC Data
    inout AUD_DACLRCK,       // Audio CODEC DAC LR Clock
    output AUD_DACDAT,       // Audio CODEC DAC Data
    inout AUD_BCLK,          // Audio CODEC Bit-Stream Clock
    output AUD_XCK,          // Audio CODEC Chip Clock
    // TV Decoder
    input [7:0] TD_DATA,     // TV Decoder Data Bus
    input TD_HS,             // TV Decoder H_SYNC
    input TD_VS,             // TV Decoder V_SYNC
    output TD_RESET,         // TV Decoder Reset
    input TD_CLK27,          // TV Decoder 27MHz CLK
    // GPIO
    inout [35:0] GPIO_0,     // GPIO Connection 0
    inout [35:0] GPIO_1      // GPIO Connection 1
);
    TopLevel toplevel(
        .clock(CLOCK_50),
        .rst(SW[0]),
        .forwardEn(SW[1]),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_OE_N(SRAM_DE_N)
    );
endmodule
