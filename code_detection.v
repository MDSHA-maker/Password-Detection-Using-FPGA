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


module code_detection(
    input               clk,
    input               reset,
    input               btnR,
    input               btnL,
    input               btnU,
    input               btnD,
    input               sw,
    output reg  [6:0]   SSG_D,
    output      [2:0]   SSG_EN  //disable three of four
    );
    
    parameter   IDLE    =   0;
    parameter   BTR1    =   1;
    parameter   BTL1    =   1;
	parameter   BTU1    =   1;
	parameter   BTD1    =   1;
    parameter   BTR0    =   2;
    parameter   BTL0    =   2;
	parameter   BTU0    =   2;
	parameter   BTD0    =   2;
        
    parameter   STATE_IDLE      = 0;
    parameter   STATE_TOP       = 1;
    parameter   STATE_LEFT1     = 2;
    parameter   STATE_LEFT2     = 3;
    parameter   STATE_ERROR     = 4;
    parameter   STATE_SUCC      = 5;
    parameter   STATE_FAILED    = 6;
		
	parameter 	TIMEOUT_COUNT 	= 32'd1000_000_000;
    
    reg   [3:0]     state;
    reg   [3:0]     next_state;
    reg   [1:0]     buttonR;
	reg   [1:0]     next_buttonR;
    reg   [1:0]     buttonL;
    reg   [1:0]     next_buttonL;
    reg   [1:0]     buttonU;
    reg   [1:0]     next_buttonU;
    reg   [1:0]     buttonD;
    reg   [1:0]     next_buttonD;
    reg   [2:0]     count;
    reg   [2:0]     next_count;
    reg   [3:0]     character;
    reg   [3:0]     next_character;
    reg   [31:0]	timer;
    reg   [1:0] 	attempt;
    reg             timer_en;
    
    wire        pressed;
    wire        timeout;
    wire        timer_start;
    wire        timer_rst;
    wire        attempt_plus;
    wire        valid;
    wire        bit0, bit1, bit2, bit3;
    wire [3:0]  button_bits;
		
    assign pressed      = ((buttonR == BTR0) || (buttonL == BTL0) || (buttonU == BTU0) || (buttonD == BTD0));
    assign bit0         = (buttonR == BTR0);
    assign bit1         = (buttonL == BTL0);
    assign bit2         = (buttonU == BTU0);
    assign bit3         = (buttonD == BTD0);
    assign button_bits  = {bit3, bit2, bit1, bit0};
    assign valid        = ((button_bits == 0) || (button_bits == 1) || (button_bits == 2) || (button_bits == 4) || (button_bits == 8));
    
  //logic to determine next state
    always@(*)begin
        case(buttonR)
            IDLE:
                if(btnR)
                    next_buttonR = BTR1;
                else 
                    next_buttonR = IDLE;
            BTR1:
                if(!btnR)
                    next_buttonR = BTR0;
                else 
                    next_buttonR = BTR1;
            BTR0:
                next_buttonR = IDLE;
            default:
                next_buttonR = IDLE;      
        endcase
    end

    always@(posedge clk or posedge reset) begin
        if(reset)
            buttonR  <=  IDLE;
        else 
            buttonR <=  next_buttonR;
    end
  
   always@(*)begin
        case(buttonL)
            IDLE:
                if(btnL)
                    next_buttonL = BTL1;
                else 
                    next_buttonL = IDLE;
            BTL1:
                if(!btnL)
                    next_buttonL = BTL0;
                else 
                    next_buttonL = BTL1;
            BTL0:
                next_buttonL = IDLE;
            default:
              next_buttonL = IDLE;      
        endcase
    end

    always@(posedge clk or posedge reset) begin
        if(reset)
            buttonL  <=  IDLE;
        else 
            buttonL <=  next_buttonL;
    end
    always@(*)begin
        case(buttonU)
            IDLE:
                if(btnU)
                    next_buttonU = BTU1;
                else 
                    next_buttonU = IDLE;
            BTU1:
                if(!btnU)
                    next_buttonU = BTU0;
                else 
                    next_buttonU = BTU1;
            BTU0:
                next_buttonU = IDLE;
            default:
                next_buttonU = IDLE;      
        endcase
    end

    always@(posedge clk or posedge reset) begin
        if(reset)
            buttonU  <=  IDLE;
        else 
            buttonU <=  next_buttonU;
    end
    
    always@(*)begin
        case(buttonD)
            IDLE:
                if(btnD)
                    next_buttonD = BTD1;
                else 
                    next_buttonD = IDLE;
            BTD1:
                if(!btnD)
                    next_buttonD = BTD0;
                else 
                    next_buttonD = BTD1;
            BTD0:
                next_buttonD = IDLE;
            default:
                next_buttonD = IDLE;      
        endcase
    end

    always@(posedge clk or posedge reset) begin
        if(reset)
            buttonD  <=  IDLE;
        else 
            buttonD <=  next_buttonD;
    end
            
 //logic to determine next state
    always@(*)begin
        case(state)
            STATE_IDLE: begin
                if(pressed) begin
                    next_character = 4'b0000;
                    next_count = count + 1;
                    if((((buttonU == BTU0) && !sw) || ((buttonD == BTD0) && sw)) && valid)
                        next_state = STATE_TOP;
                    else 
                        next_state = STATE_ERROR;
                end
                else begin
                    next_character = character;
                    next_count = 0;
                    next_state = STATE_IDLE;
                end
            end
            STATE_TOP: begin
                next_character = character;
                if(pressed) begin
                    next_count = count + 1;
                    if((((buttonL == BTL0) && !sw) || ((buttonR == BTR0) && sw)) && valid)
                        next_state = STATE_LEFT1;
                    else 
                        next_state = STATE_ERROR;
                end
                else begin
                    next_count = count;
                    next_state = STATE_TOP;
                end
            end
            STATE_LEFT1: begin
                next_character = character;
                if(pressed) begin
                    next_count = count + 1;
                    if((((buttonL == BTL0) && !sw) || ((buttonR == BTR0) && sw)) && valid)
                        next_state = STATE_LEFT2;
                    else 
                        next_state = STATE_ERROR;
                end
                else begin
                    next_count = count;
                    next_state = STATE_LEFT1;
                end
            end
            STATE_LEFT2: begin
                next_character = character;
                if(pressed) begin
                    next_count = count + 1;
                    if((((buttonR == BTR0) && !sw) || ((buttonL == BTL0) && sw)) && valid)
                        next_state = STATE_SUCC;
                    else 
                        next_state = STATE_ERROR;
                end
                else begin
                    next_count = count;
                    next_state = STATE_LEFT2;
                end
            end
            STATE_SUCC: begin
                next_character = 4'b1001;
                next_count = count;
                next_state = STATE_SUCC;
            end
            STATE_ERROR: begin
                if(pressed)
                    next_count = count + 1;
                else
                    next_count = count;
										
                if(next_count == 4) begin
                    next_character = 4'b1010;
                    if(attempt == 2)
                        next_state = STATE_FAILED;
                    else
                        next_state = STATE_IDLE;
				end
                else begin
                    next_character = character;
                    next_state = STATE_ERROR;
                end
            end
            STATE_FAILED: begin
                next_character = 4'b1010;
                next_count = count;
                next_state = STATE_FAILED;
            end
            default: begin
                next_character = 4'b0000;
                next_count = 0;
                next_state = STATE_IDLE;
            end    
        endcase
    end

  //update state registers 
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            state  	  <=  STATE_IDLE;
        end
        else begin
            if(timeout)
                state <=  STATE_FAILED;
            else
                state <=  next_state;
	    end
    end

    assign timeout      = (timer == TIMEOUT_COUNT);
    assign timer_start  = ((state == STATE_IDLE) && pressed);
    assign timer_rst    = (((next_state == STATE_IDLE) && (state == STATE_ERROR)) || (state == STATE_SUCC));
    
  //update state registers 
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            timer 		<= 32'd0;
            timer_en    <= 1'b0;
        end
        else begin
            if(timer_rst) begin
                timer 	 <= 32'd0;
                timer_en <= 1'b0;
            end
            else if(timer_start) begin
                timer_en <= 1'b1;
            end
            else if(!timeout && timer_en) begin
                timer 	 <= timer + 1;
            end
	   end
    end
 
    assign attempt_plus = ((state == STATE_ERROR) && (next_count == 4));
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            attempt     <= 2'd0;
        end
        else begin         
            if(attempt_plus)
                attempt <= attempt + 1;
        end
    end
        
  //update state registers 
    always@(posedge clk or posedge reset) begin
        if(reset)
            count  <=  0;
        else 
           count <=  next_count;
    end
    
  //update state registers 
    always@(posedge clk or posedge reset) begin
        if(reset)
             character  <=  4'b0000;
        else 
             character <=  next_character;
    end
    
    // send the counter output to 7 segment LED for display.   
    always@(*)begin                // decoder circuit for 7 segment LED
        case(character)
            4'b0000: SSG_D = 7'b1000000; //0
            4'b0001: SSG_D = 7'b1111001; //1
            4'b0010: SSG_D = 7'b0100100; //2
            4'b0011: SSG_D = 7'b0110000; //3 
            4'b0100: SSG_D = 7'b0011001; //4
            4'b0101: SSG_D = 7'b0010010; //5
            4'b0110: SSG_D = 7'b0000010; //6
            4'b0111: SSG_D = 7'b1111000; //7
            4'b1000: SSG_D = 7'b0000000; //8
            4'b1001: SSG_D = 7'b0010000; //9
			4'b1010: SSG_D = 7'b0000110; //E
            default: SSG_D = 7'b1111111; //none
        endcase
    end 
      
    assign      SSG_EN  =   3'b111;   // disable the other three LEDs
    
endmodule
