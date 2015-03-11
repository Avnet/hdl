  module  tcm_receiver_axis_intf # (
    parameter integer C_PIXEL_WIDTH         = 8,
    parameter integer C_AXIS_DATA_WIDTH     = 8
  )
  (
    input   wire            reset,
    input   wire            clk,

    input   wire            empty0,
    output  wire            rden0,
    input   wire  [11: 0]   rdat0,

    input   wire            empty1,
    output  wire            rden1,
    input   wire  [11: 0]   rdat1,

    output  wire            tvalid,
    input   wire            tready,
    output  wire            tuser,
    output  wire            tlast,
    output  wire  [C_AXIS_DATA_WIDTH - 1:0] tdata
  );

  // Wires and Registers
  reg             parity;

  // Read Parity
  always @ (posedge clk)
  begin
    if (reset)
      parity  <= 1'b0;
    else if (tvalid && tready)
      parity  <= ~parity;
  end

  // FIFO Interface
  assign        rden0       = ~parity & tvalid & tready;
  assign        rden1       =  parity & tvalid & tready;

  // AXIS Interface
  assign        tvalid      = parity ? ~empty1 : ~empty0;
  assign        tuser       = ~parity & rdat0[11];
  assign        tlast       =  parity & rdat1[10];

  generate

  if (C_AXIS_DATA_WIDTH == 8)
  begin
  assign        tdata       = parity ? rdat1[ 9: 2] : rdat0[ 9: 2];
  end
  else
  begin
  assign        tdata       = parity ? {6'd0, rdat1[ 9: 0]} : {6'd0, rdat0[ 9: 0]};
  end

  endgenerate

  endmodule
