`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2019 01:34:11 PM
// Design Name: 
// Module Name: code_detection
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input               clk,
    input               reset,
    input               btnR,
    input               btnL,
    input               btnU,
    input               btnD,
    input               sw,
    output      [6:0]   SSG_D,
    output      [2:0]   SSG_EN
);

//parameter   TIMEOUT_COUNT   = 1000_000_000;
parameter   TIMEOUT_COUNT   = 200;
//parameter   TIMER_COUNT     = 1000_000;
parameter   TIMER_COUNT     = 10;

wire DbtnR;
wire DbtnL;
wire DbtnU;
wire DbtnD;

code_detection #(
   .TIMEOUT_COUNT  (TIMEOUT_COUNT)
) uut (
    .clk        (clk),
    .reset      (reset),
    .btnR       (DbtnR),
    .btnL       (DbtnL),
    .btnU       (DbtnU),
    .btnD       (DbtnD),
    .sw         (sw),
    .SSG_D      (SSG_D),
    .SSG_EN     (SSG_EN)
);

debouncer #(
    .TIMER_COUNT    (TIMER_COUNT)
) uut1 (
    .clk        (clk),
    .reset      (reset),
    .btnI       (btnR),
    .btnO       (DbtnR)
);

debouncer #(
    .TIMER_COUNT    (TIMER_COUNT)
) uut2 (
    .clk        (clk),
    .reset      (reset),
    .btnI       (btnL),
    .btnO       (DbtnL)
);

debouncer #(
    .TIMER_COUNT    (TIMER_COUNT)
) uut3 (
    .clk        (clk),
    .reset      (reset),
    .btnI       (btnU),
    .btnO       (DbtnU)
);

debouncer #(
    .TIMER_COUNT    (TIMER_COUNT)
) uut4 (
    .clk        (clk),
    .reset      (reset),
    .btnI       (btnD),
    .btnO       (DbtnD)
);
  
endmodule
