`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AVNET
// Engineer: kris Gao
// 
// Create Date: 2018/09/04 22:52:47
// Design Name: 
// Module Name: fixed_value_asign
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


module Subset 
 #(
   
    parameter C_COLOR_FORMAT     = "YUV422",
	
    parameter C_INPUT_DATAWIDTH  = 16 ,
	
	parameter C_OUTPUT_DATAWIDTH = 36

	
   )(

    

   input       [C_INPUT_DATAWIDTH-1 : 0  ]  Din,
   
   output wire [C_OUTPUT_DATAWIDTH-1 : 0 ]  Dout 
 
    );
	
	
   generate 

    
        if ( C_COLOR_FORMAT == "YUV422" )begin :YUV422
           
		   assign  Dout [35:28]  = Din[15:8]; //Cb/Cr
 
           assign  Dout [23:16]  = Din[7:0];  //Y
		   
         end          
    
   endgenerate
    
    
endmodule
