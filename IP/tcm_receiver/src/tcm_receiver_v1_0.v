
`timescale 1 ns / 1 ps

  module tcm_receiver_v1_0 #
  (
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line


    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH  = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH  = 4,
    parameter integer C_PIXEL_WIDTH         = 8,
    parameter integer C_AXIS_DATA_WIDTH     = 8
  )
  (
    // Users to add ports here
    input wire reset,
    input wire ref_200_clk_in,
    input wire io_tcm_clk_in_p,
    input wire io_tcm_clk_in_n,
    input wire [1:0] io_tcm_data_in_p,
    input wire [1:0] io_tcm_data_in_n,
    output wire io_tcm_clk_out,

    input wire aclk,
    output wire m_axis_tvalid,
    input wire m_axis_tready,
    output wire m_axis_tuser,
    output wire m_axis_tlast,
    output wire [C_AXIS_DATA_WIDTH - 1:0] m_axis_tdata,

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
  wire          host_iserdes_reset;

  wire          tcm_clk_div;
  reg           tcm_reset;
  wire  [19: 0] tcm_iserdes_data;

  wire  [ 9: 0] tcm_iserdes_data_p0;
  wire  [ 9: 0] tcm_bitalign_data_p0;
  wire  [12: 0] tcm_detect_data_p0;

  wire  [ 9: 0] tcm_iserdes_data_p1;
  wire  [ 9: 0] tcm_bitalign_data_p1;
  wire  [12: 0] tcm_detect_data_p1;

  wire          tcm_fifo_full_p0;
  wire          tcm_fifo_empty_p0;
  wire          tcm_fifo_rden_p0;
  wire  [11: 0] tcm_fifo_rdat_p0;

  wire          tcm_fifo_full_p1;
  wire          tcm_fifo_empty_p1;
  wire          tcm_fifo_rden_p1;
  wire  [11: 0] tcm_fifo_rdat_p1;

  // Debug Related
  reg   [10 :0] pixel_cnt;
  reg   [10 :0] line_cnt;

  always @ (posedge tcm_clk_div)
  begin
    if (reset)
    begin
      pixel_cnt   <= 10'd0;
      line_cnt    <= 10'd0;
    end
    else
    begin
      if (tcm_detect_data_p0[11])
        line_cnt  <= 10'd0;
      else if (tcm_detect_data_p0[10])
        line_cnt  <= line_cnt + 1'b1;

      if (tcm_detect_data_p0[10])
        pixel_cnt <= 10'd0;
      else if (tcm_detect_data_p0[12])
        pixel_cnt <= pixel_cnt + 1'b1;
    end
  end

  assign        io_tcm_clk_out = tcm_clk_div;

  tcm_receiver_v1_0_S00_AXI # (
    .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
  ) tcm_receiver_v1_0_S00_AXI_inst (
    .host_iserdes_reset(host_iserdes_reset),
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

  always @ (posedge tcm_clk_div)
  begin
    if (host_iserdes_reset)
      tcm_reset  <= 1'b1;
    else
      tcm_reset  <= 1'b0;
  end

  selectio_wiz_0 selectio_wiz_0_inst (
    .data_in_from_pins_p    ( io_tcm_data_in_p[1:0]               ), // input wire [1 : 0] data_in_from_pins_p
    .data_in_from_pins_n    ( io_tcm_data_in_n[1:0]               ), // input wire [1 : 0] data_in_from_pins_n
    .clk_in_p               ( io_tcm_clk_in_p                     ), // input wire clk_in_p
    .clk_in_n               ( io_tcm_clk_in_n                     ), // input wire clk_in_n
    .clk_reset              ( 1'b0                                ), // input wire clk_reset
    .io_reset               ( tcm_reset                           ), // input wire io_reset
    .bitslip                ( 1'b0                                ), // input wire bitslip
    .clk_div_out            ( tcm_clk_div                         ), // output wire clk_div_out
    .data_in_to_device      ( tcm_iserdes_data[19: 0]             )  // output wire [19 : 0] data_in_to_device
  );

  assign            tcm_iserdes_data_p0  = {tcm_iserdes_data[ 0], tcm_iserdes_data[ 2],
                                            tcm_iserdes_data[ 4], tcm_iserdes_data[ 6],
                                            tcm_iserdes_data[ 8], tcm_iserdes_data[10],
                                            tcm_iserdes_data[12], tcm_iserdes_data[14],
                                            tcm_iserdes_data[16], tcm_iserdes_data[18]};
  assign            tcm_iserdes_data_p1  = {tcm_iserdes_data[ 1], tcm_iserdes_data[ 3],
                                            tcm_iserdes_data[ 5], tcm_iserdes_data[ 7],
                                            tcm_iserdes_data[ 9], tcm_iserdes_data[11],
                                            tcm_iserdes_data[13], tcm_iserdes_data[15],
                                            tcm_iserdes_data[17], tcm_iserdes_data[19]};

  // Bit Alignment

  tcm_receiver_bitalign tcm_receiver_bitalign_p0_inst (
    .reset                  ( tcm_reset                           ),
    .clk                    ( tcm_clk_div                         ),

    .rdat                   ( tcm_iserdes_data_p0[ 9: 0]          ),
    .wdat                   ( tcm_bitalign_data_p0[ 9: 0]         )
  );

  tcm_receiver_bitalign tcm_receiver_bitalign_p1_inst (
    .reset                  ( tcm_reset                           ),
    .clk                    ( tcm_clk_div                         ),

    .rdat                   ( tcm_iserdes_data_p1[ 9: 0]          ),
    .wdat                   ( tcm_bitalign_data_p1[ 9: 0]         )
  );

  // Sync Code Detection

  tcm_receiver_detect tcm_receiver_detect_p0_inst (
    .reset                  ( tcm_reset                           ),
    .clk                    ( tcm_clk_div                         ),

    .rdat                   ( tcm_bitalign_data_p0[ 9: 0]         ),
    .wdat                   ( tcm_detect_data_p0[12: 0]           )
  );

  tcm_receiver_detect tcm_receiver_detect_p1_inst (
    .reset                  ( tcm_reset                           ),
    .clk                    ( tcm_clk_div                         ),

    .rdat                   ( tcm_bitalign_data_p1[ 9: 0]         ),
    .wdat                   ( tcm_detect_data_p1[12: 0]           )
  );

  // Output FIFO
  fifo_generator_0 tcm_receiver_fifo_p0_inst (
    .rst                    ( tcm_reset                           ),  // input wire rst
    .wr_clk                 ( tcm_clk_div                         ),  // input wire wr_clk
    .rd_clk                 ( aclk                                ),  // input wire rd_clk
    .din                    ( tcm_detect_data_p0[11: 0]           ),  // input wire [11 : 0] din
    .wr_en                  ( tcm_detect_data_p0[12]              ),  // input wire wr_en
    .rd_en                  ( tcm_fifo_rden_p0                    ),  // input wire rd_en
    .dout                   ( tcm_fifo_rdat_p0[11: 0]             ),  // output wire [11 : 0] dout
    .full                   ( tcm_fifo_full_p0                    ),  // output wire full
    .empty                  ( tcm_fifo_empty_p0                   )   // output wire empty
  );

  fifo_generator_0 tcm_receiver_fifo_p1_inst (
    .rst                    ( tcm_reset                           ),  // input wire rst
    .wr_clk                 ( tcm_clk_div                         ),  // input wire wr_clk
    .rd_clk                 ( aclk                                ),  // input wire rd_clk
    .din                    ( tcm_detect_data_p1[11: 0]           ),  // input wire [11 : 0] din
    .wr_en                  ( tcm_detect_data_p1[12]              ),  // input wire wr_en
    .rd_en                  ( tcm_fifo_rden_p1                    ),  // input wire rd_en
    .dout                   ( tcm_fifo_rdat_p1[11: 0]             ),  // output wire [11 : 0] dout
    .full                   ( tcm_fifo_full_p1                    ),  // output wire full
    .empty                  ( tcm_fifo_empty_p1                   )   // output wire empty
  );

  tcm_receiver_axis_intf # (
    .C_PIXEL_WIDTH          ( C_PIXEL_WIDTH                       ) ,
    .C_AXIS_DATA_WIDTH      ( C_AXIS_DATA_WIDTH                   )
  ) tcm_receiver_axis_intf_inst (
    .reset                  ( tcm_reset                           ),
    .clk                    ( aclk                                ),

    .empty0                 ( tcm_fifo_empty_p0                   ),
    .rden0                  ( tcm_fifo_rden_p0                    ),
    .rdat0                  ( tcm_fifo_rdat_p0[11: 0]             ),

    .empty1                 ( tcm_fifo_empty_p1                   ),
    .rden1                  ( tcm_fifo_rden_p1                    ),
    .rdat1                  ( tcm_fifo_rdat_p1[11: 0]             ),

    .tvalid                 ( m_axis_tvalid                       ),
    .tready                 ( m_axis_tready                       ),
    .tuser                  ( m_axis_tuser                        ),
    .tlast                  ( m_axis_tlast                        ),
    .tdata                  ( m_axis_tdata[C_AXIS_DATA_WIDTH - 1:0]   )
  );

  endmodule

