`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Avnet
// Engineer: JLB
// 
// Create Date: 09/10/2012 03:32:02 PM
// Design Name: 
// Module Name: PWM_Controller_Int
// Project Name: PWM Controller_Int
// Target Devices: Any Xilinx FPGA
// Tool Versions: Created in Vivado 2013.3
// Description: PWM Controller with Interrupt output to PS
// Generates Interrupt when invalid PWM range is written into block.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//          0.02 - Changing size of PWM_out vector from 8 to 1
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWM_Controller_Int #(
    parameter integer period = 20)
    (
    input Clk,
    input [31:0] DutyCycle, 
    input Reset,
    output reg [0:0] PWM_out,
	output reg Interrupt,
	output reg [period-1:0] count
    );
    
    // Sets PWM Period.  Must be calculated vs. input clk period.
    // For example, setting this to 20 will divide the input clock by 2^20, or 1 Million.
    // So a 50 MHz input clock will be divided by 1e6, thus this will have a period of 1/50
    // reg [period-1:0] count;  
    // reg [0:0] PWM_out;
    
    always @(posedge Clk)
     if (!Reset)
        count <= 0;
     else
        count <= count + 1; 
    
     always @(posedge Clk)
       if (count < DutyCycle)
           PWM_out <= 1;
       else
           PWM_out <= 0; 
		   
	 always @(posedge Clk)
       if (!Reset)
           Interrupt <= 0;
       else if (DutyCycle > 990000)
           Interrupt <= 1;
       else
           Interrupt <= 0; 
        
endmodule
