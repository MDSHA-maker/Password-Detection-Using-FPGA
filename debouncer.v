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


module debouncer(
    input               clk,
    input               reset,
    input               btnI,
    output              btnO
);
    		
	parameter 	TIMER_COUNT 	= 32'd1000_000;
    
    reg             state;
    reg   [31:0]	timer;
    
    assign btnO = state;

    always@(posedge clk or posedge reset) begin
      if(reset) begin
        state  	    <= 1'b0;
        timer 		<= 32'd0;
      end
      else begin
         if (btnI != state) begin
            timer <= timer + 1;
            if(timer == TIMER_COUNT)
                state <= btnI;
         end
         else begin
            timer <= 32'd0;
         end
	  end
    end
        
endmodule
