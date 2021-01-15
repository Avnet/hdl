//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : board.v
// Version    : 3.3
// Description:  Top level testbench
//
//------------------------------------------------------------------------------

`timescale 1ns/1ns

`include "board_common.vh"

`define SIMULATION

module board;

parameter          REF_CLK_FREQ       = 0;      // 0 - 100 MHz, 1 - 125 MHz,  2 - 250 MHz

localparam         REF_CLK_HALF_CYCLE = (REF_CLK_FREQ == 0) ? 5000 :
                                        (REF_CLK_FREQ == 1) ? 4000 :
                                        (REF_CLK_FREQ == 2) ? 2000 : 0;
integer            i;

// System-level clock and reset
reg                sys_rst_n;

wire               ep_sys_clk_p;
wire               ep_sys_clk_n;
wire               ep_sys_clk;
wire               rp_sys_clk;


localparam EXT_PIPE_SIM = "FALSE";


//
// PCI-Express Serial Interconnect
//

wire  [0:0]  ep_pci_exp_txn;
wire  [0:0]  ep_pci_exp_txp;
wire  [0:0]  rp_pci_exp_txn;
wire  [0:0]  rp_pci_exp_txp;
//
// PCI-Express Endpoint Instance
//

xilinx_pcie_2_1_ep_7x 
  

EP (


  // SYS Inteface
  .sys_clk_n(ep_sys_clk_n),
  .sys_clk_p(ep_sys_clk_p),
  .sys_rst_n(sys_rst_n),



  // PCI-Express Interface
  .pci_exp_txn(ep_pci_exp_txn),
  .pci_exp_txp(ep_pci_exp_txp),
  .pci_exp_rxn(rp_pci_exp_txn),
  .pci_exp_rxp(rp_pci_exp_txp)
);

//
// PCI-Express Model Root Port Instance
//

xilinx_pcie_2_1_rport_7x # (

  .REF_CLK_FREQ(0),
  .PL_FAST_TRAIN("TRUE"),
  .ALLOW_X8_GEN2("FALSE"),
  .C_DATA_WIDTH(64),
  .LINK_CAP_MAX_LINK_WIDTH(6'h1),
  .DEVICE_ID(16'h7100),
  .LINK_CAP_MAX_LINK_SPEED(4'h1),
  .LINK_CTRL2_TARGET_LINK_SPEED(4'h1),
  .DEV_CAP_MAX_PAYLOAD_SUPPORTED(2),
  .TRN_DW("FALSE"),
  .VC0_TX_LASTPACKET(29),
  .VC0_RX_RAM_LIMIT(13'h7FF),
  .VC0_CPL_INFINITE("TRUE"),
  .VC0_TOTAL_CREDITS_PD(437),
  .VC0_TOTAL_CREDITS_CD(461),
  .USER_CLK_FREQ(1),
  .USER_CLK2_DIV2("FALSE")
)
RP (

  // SYS Inteface
  .sys_clk(rp_sys_clk),
  .sys_rst_n(sys_rst_n),

  // PCI-Express Interface
  .pci_exp_txn(rp_pci_exp_txn),
  .pci_exp_txp(rp_pci_exp_txp),
  .pci_exp_rxn(ep_pci_exp_txn),
  .pci_exp_rxp(ep_pci_exp_txp)
);


sys_clk_gen  # (

  .halfcycle(REF_CLK_HALF_CYCLE),
  .offset(0)

)
CLK_GEN_RP (

  .sys_clk(rp_sys_clk)

);


sys_clk_gen_ds # (

  .halfcycle(REF_CLK_HALF_CYCLE),
  .offset(0)

)
CLK_GEN_EP (

  .sys_clk_p(ep_sys_clk_p),
  .sys_clk_n(ep_sys_clk_n)

);





initial begin
  $display("[%t] : System Reset Asserted...", $realtime);

  sys_rst_n = 1'b0;

  for (i = 0; i < 500; i = i + 1) begin

    @(posedge ep_sys_clk_p);

  end

  $display("[%t] : System Reset De-asserted...", $realtime);

  sys_rst_n = 1'b1;

end



initial begin

  if ($test$plusargs ("dump_all")) begin

`ifdef NCV // Cadence TRN dump

    $recordsetup("design=board",
                 "compress",
                 "wrapsize=100M",
                 "version=1",
                 "run=1");
    $recordvars();

`elsif VCS //Synopsys VPD dump

    $vcdplusfile("board.vpd");
    $vcdpluson;
    $vcdplusglitchon;
    $vcdplusflush;

`else

    // Verilog VC dump
    $dumpfile("board.vcd");
    $dumpvars(0, board);

`endif

  end

end


endmodule // BOARD
