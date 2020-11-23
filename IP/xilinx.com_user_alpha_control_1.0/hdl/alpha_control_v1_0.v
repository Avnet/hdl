
`timescale 1 ns / 1 ps

	module alpha_control_v1_0 #
	(
		// Users to add parameters here
         parameter C_DATAWIDTH = 8,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		
		input  video_clk ,
		
		input  resetn,
		
		input  video_hsync ,
		
		input  video_vsync ,
		
	(* MARK_DEBUG="true" *)	input  video_active ,
		
	(* MARK_DEBUG="true" *)	input  [15:0]video_din,
		
		
		output reg video_hsync_out ,
		
		output reg video_vsync_out,
		
	(* MARK_DEBUG="true" *)	output reg video_active_out ,
		
	(* MARK_DEBUG="true" *)	output reg [15:0] video_dout,
		
        output [7 :0] alpha,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
   
   wire  [C_DATAWIDTH-1 :0] YUV_order ;
	
	
	alpha_control_v1_0_S00_AXI # ( 
	    .C_DATAWIDTH(C_DATAWIDTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) alpha_control_v1_0_S00_AXI_inst (
	    
		.YUV_order(YUV_order),
	    .alpha (alpha),
	    
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here

  
	  
     (* dont_touch="true" *) (* keep="true" *) reg [23:0] Y;
	 (* dont_touch="true" *) (* keep="true" *) reg [15:0] U;
	 (* dont_touch="true" *) (* keep="true" *) reg [15:0] V;
	  
	(* MARK_DEBUG="true" *)  reg [C_DATAWIDTH-1 :0]yuv_order;
	  
	  reg UV_sel;
	  
	  (* dont_touch="true" *) (* keep="true" *)reg vsync_int1;
	  (* dont_touch="true" *) (* keep="true" *)reg vsync_int2;
	  
	  (* dont_touch="true" *) (* keep="true" *)reg hsync_int1;
	  (* dont_touch="true" *) (* keep="true" *)reg hsync_int2;
	  
	  (* dont_touch="true" *) (* keep="true" *)reg active_int1;
	  (* dont_touch="true" *) (* keep="true" *)reg active_int2;
	  
	  (* dont_touch="true" *) (* keep="true" *)reg [15:0] video_din_int1;
	  (* dont_touch="true" *) (* keep="true" *)reg [15:0] video_din_int2;
	  
	  
      always@(posedge video_clk) begin
	  
	   if(resetn==0 ) begin
	   
	    Y <=0;
		U <=0;
		V <=0;
		UV_sel <=0;
	    yuv_order <=0 ;
		              
		hsync_int1 <= 0;
		hsync_int2 <= 0;
		             
		vsync_int1 <= 0;
		vsync_int2 <= 0;
		             
		active_int1 <=0;
		active_int2 <=0;
		              
		video_din_int1 <=0;
		video_din_int2 <=0;
		
	  
	  video_hsync_out <=0;
	  video_vsync_out <=0;
	  video_active_out<=0;   
	   video_dout     <=0;
	   
	   end
	   else begin
	    hsync_int1 <= video_hsync;	
		hsync_int2 <= hsync_int1;
		
		vsync_int1 <= video_vsync;
		vsync_int2 <= vsync_int1;
		
		active_int1 <= video_active;
		active_int2 <= active_int1;
		
		
	  
	  video_hsync_out <= hsync_int2 ;
	  video_vsync_out <= vsync_int2 ;
	  video_active_out<= active_int2 ;
	 
       
       if(video_vsync==1)
              yuv_order <= YUV_order ;
			  
	   
  
    case(yuv_order)	 
	  
	 8'd0: 
	       begin 
	  
	   if(video_active==1||active_int2==1) begin
	 
	  
         Y <= {video_din[7:0] ,Y[23:8] };
		 
		 UV_sel <= ~UV_sel;
		 
		 if( UV_sel==0 ) 
		 U <= {video_din[15:8], U[15:8]};
		 else if( UV_sel==1 ) 
	  	 V <= {video_din[15:8] ,V[15:8]};
	  
	    end  
		
	  else begin
	  
	     UV_sel <=  0;
	     
	  end
	  
	  

		 	     if ( UV_sel==0)  video_dout <= {V[15:8],Y[15:8]};
		    	   
	     else if( UV_sel==1 )     video_dout <= {U[7:0],Y[15:8]};
		      
		  end
    
      8'd1 :
              begin
				
	   if(video_active==1||active_int2==1) begin
	 
	  
         Y <= {video_din[7:0] ,Y[23:8] };
		 
		 UV_sel <= ~UV_sel;
		 
		 if( UV_sel==0 ) 
		 U <= {video_din[15:8], U[15:8]};
		 else if( UV_sel==1 ) 
	  	 V <= {video_din[15:8] ,V[15:8]};
	  
	    end  
		
	  else begin
	  
	     UV_sel <=  0;
	     
	  end
	  
	  

		 	     if ( UV_sel==0)  video_dout <= {Y[15:8],V[15:8]};
		    	   
	     else if( UV_sel==1 )     video_dout <= {Y[15:8],U[7:0]};



                end

     8'd2 :    
            begin

              video_din_int1 <= video_din ;
			  video_din_int2 <= video_din_int1;
			  video_dout     <= video_din_int2;
			  

            end
     8'd3 :    
            begin

              video_din_int1 <= video_din ;
			  video_din_int2 <= video_din_int1;
			  video_dout     <= {video_din_int2[7:0],video_din_int2[15:8]};

            end			
     default :			
			   begin

               end

     endcase			   
	  
	  
	  end
	  
	  end


	// User logic ends

	endmodule
