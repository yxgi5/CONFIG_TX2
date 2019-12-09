// clk_div_5_5_tb.v
// Testbench

`timescale 1ns/ 1ps
//`define CheckByteNum 6000
//`ifndef xx
//`define xx yy // or parameter xx = yy;
//`endif
//`undef XX

module CONFIG_TX_tb();

reg     RESET_tb;
reg     UCLOCK_tb;  // 48MHz system clock.
reg     INPUT_tb;
reg     START_tb;

wire    CONFIG_DONE_tb;

//wire                            TX_END_tb;
wire                            TX_DAT_tb;
wire                            TX_CLK_tb;
wire                            TX_OE_N_tb;
wire                            TX_OE_tb;

wire    [15:0]                  pdata;
wire    [2:0]                   paddr;
wire                            rd_en;

reg     i;


CONFIG_TX
#(
    .CLOCK_PERIOD_PS            (20833),    // 48MHz
    .BIT_PERIOD_NS              (400),      // 2.5MHz
    .C_NO_CFG_BITS              (24),
    .CFG_REGS                   (2)
)UUT9
(
    .RESET                      (RESET_tb),
    .CLOCK                      (UCLOCK_tb),
    .START                      (START_tb),
    .LINE_PERIOD                (16'd4000),
    .INPUT                      (pdata),
    .RD_ADDR                    (paddr),
    .RD_EN                      (rd_en),
    .TX_END                     (CONFIG_DONE_tb),
    .TX_DAT                     (TX_DAT_tb),
    .TX_CLK                     (TX_CLK_tb),
    .TX_OE                      (TX_OE_tb)
);


CONV_REGS UUT10
(
    .CLOCK                      (UCLOCK_tb),                                      // 48MHz system clock
    .RESET                      (RESET_tb),                                      // reset active high

    .WE_A                       (1'b0),                                        //
    .ADD_A                      (3'b000),                                      // 
    .DAT_A                      (8'h00),                                      //

    .RE_B                       (rd_en),
    .ADD_B                      (paddr[1:0]),                                      // 
    .DAT_B                      (pdata)                                       //
);


assign      TX_OE_N_tb  =       ~TX_OE_tb;

initial
begin
    i = 0;
    UCLOCK_tb = 1;
    RESET_tb = 1;
    START_tb = 0;
    #40
    RESET_tb = 0;

    # 10000000 i=1;
    
    while(i)
    begin
        #1000 START_tb = 1;
        #50000 START_tb = 0;
    end
end

always
begin
    #10 UCLOCK_tb = ~UCLOCK_tb; // 50MHz sample clock
end

//always
//begin
//    #1000000 START_tb = 1;
//    #50000000 START_tb = 0;
//end

endmodule


