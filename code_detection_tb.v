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

module code_detection_tb();

parameter PERIOD = 10;

reg             clk;
reg             reset;
reg             btnR, btnL, btnU, btnD;
reg             sw;
wire    [6:0]   SSG_D;
reg     [7:0]   SSG_C;
wire    [2:0]   SSG_EN;

initial begin
    clk     <= 1'b0;
    reset   <= 1'b1;
    btnR    <= 1'b0;
    btnL    <= 1'b0;
    btnU    <= 1'b0;
    btnD    <= 1'b0;
    sw      <= 1'b0;
    
    #PERIOD reset   <= 1'b0;
    
    #(12*PERIOD) btnU    <= 1'b1;
    #(12*PERIOD) btnU    <= 1'b0;
    #(12*PERIOD) btnL    <= 1'b1;
    #(12*PERIOD) btnL    <= 1'b0;
    #(12*PERIOD) btnL    <= 1'b1;
    #(12*PERIOD) btnL    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(30*PERIOD);
    
    #PERIOD reset   <= 1'b1;
    #PERIOD reset   <= 1'b0;
    
    #(12*PERIOD) btnU    <= 1'b1;
    #(12*PERIOD) btnU    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(12*PERIOD) btnL    <= 1'b1;
    #(12*PERIOD) btnL    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(20*PERIOD);
    
    #PERIOD      btnU    <= 1'b1;
    #(2*PERIOD)  btnU    <= 1'b0;
    #PERIOD      btnU    <= 1'b1;
    #(3*PERIOD)  btnU    <= 1'b0;
    #PERIOD      btnU    <= 1'b1;
    #(12*PERIOD) btnU    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(12*PERIOD) btnL    <= 1'b1;
    #(12*PERIOD) btnL    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(20*PERIOD);
    
    #(12*PERIOD) sw      <= 1'b1;
    
    #(12*PERIOD) btnD    <= 1'b1;
    #(12*PERIOD) btnD    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(12*PERIOD) btnL    <= 1'b1;
    #(12*PERIOD) btnL    <= 1'b0;
    #(20*PERIOD);
    
    #(12*PERIOD) btnU    <= 1'b1;
    #(12*PERIOD) btnU    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(12*PERIOD) btnL    <= 1'b1;
    #(12*PERIOD) btnL    <= 1'b0;
    #(12*PERIOD) btnR    <= 1'b1;
    #(12*PERIOD) btnR    <= 1'b0;
    #(20*PERIOD);
end

always begin
    #(PERIOD/2);
    clk <= !clk;
end

top_module #(
    .TIMEOUT_COUNT  (200),
    .TIMER_COUNT    (10)
) uut (
    .clk        (clk),
    .reset      (reset),
    .btnR       (btnR),
    .btnL       (btnL),
    .btnU       (btnU),
    .btnD       (btnD),
    .sw         (sw),
    .SSG_D      (SSG_D),
    .SSG_EN     (SSG_EN)
);

always@(*)begin                // decoder circuit for 7 segment LED
    case(SSG_D)
        7'b1000000: SSG_C = 48;  //0
        7'b1111001: SSG_C = 49;  //1
        7'b0100100: SSG_C = 50;  //2
        7'b0110000: SSG_C = 51;  //3 
        7'b0011001: SSG_C = 52;  //4
        7'b0010010: SSG_C = 53;  //5
        7'b0000010: SSG_C = 54;  //6
        7'b1111000: SSG_C = 55;  //7
        7'b0000000: SSG_C = 56;  //8
        7'b0010000: SSG_C = 57;  //9
        7'b0000110: SSG_C = 69; //E
        default:    SSG_C = 70;    //none
    endcase
end     
endmodule
