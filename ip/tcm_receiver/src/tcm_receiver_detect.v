  module  tcm_receiver_detect
  (
    input   wire            reset,
    input   wire            clk,
    input   wire  [ 9: 0]   rdat,
    output  wire  [12: 0]   wdat
  );

  // State Definition
  localparam      IDLE    = 0;
  localparam      SYNC0   = 1;        // 10'h3FF
  localparam      SYNC1   = 2;        // 10'h000
  localparam      SYNC2   = 3;        // 10'h3FF
  localparam      SYNC3   = 4;        // 10'hS0
  localparam      SYNC4   = 5;        // 10'hS1

  // Wires and Registers
  reg   [89: 0]   rdat_sr;
  reg   [ 3: 0]   cstate;
  reg   [ 3: 0]   nstate;
  reg   [ 9: 0]   sc;
  reg   [ 9: 0]   sof;
  reg   [ 9: 0]   sol;
  reg             eof;
  reg             eol;
  reg             wren;

  wire            rdat_ones     = (rdat == 10'h3FF);
  wire            rdat_zeros    = (rdat == 10'h000);

  // Input Shift Register
  always @ (posedge clk)
  begin
    if (reset)
      rdat_sr   <= 90'd0;
    else
      rdat_sr   <= {rdat_sr[79: 0], rdat};
  end

  // State Machine
  always @ (posedge clk)
  begin
    if (reset)
      cstate    <= IDLE;
    else
      cstate    <= nstate;
  end

  always @ *
  begin
    case (cstate)
    IDLE:     if (rdat_ones)        nstate  = SYNC0;
              else                  nstate  = IDLE;
    SYNC0:    if (rdat_zeros)       nstate  = SYNC1;
              else                  nstate  = IDLE;
    SYNC1:    if (rdat_ones)        nstate  = SYNC2;
              else                  nstate  = IDLE;
    SYNC2:    if (rdat_ones)        nstate  = SYNC3;
              else if (rdat_zeros)  nstate  = SYNC1;
              else                  nstate  = IDLE;
    SYNC3:                          nstate  = SYNC4;
    SYNC4:                          nstate  = IDLE;
    default:                        nstate  = IDLE;
    endcase
  end

  // Sync Code
  always @ (posedge clk)
  begin
    if (reset)
      sc   <= 10'd0;
    else if (cstate == SYNC3)
      sc   <= rdat;
  end

  always @ (posedge clk)
  begin
    if (reset)
    begin
      sof       <= 8'd0;
      sol       <= 8'd0;
      eof       <= 1'b0;
      eol       <= 1'b0;
    end
    else
    begin
      if (cstate == SYNC4)
      begin
        sof[0]    <= (sc == 10'h000) && rdat_ones;
        sol[0]    <= (sc == 10'h3FF) && rdat_ones;
        eof       <= (sc == 10'h000) && rdat_zeros;
        eol       <= (sc == 10'h3FF) && rdat_zeros;
      end
      else
      begin
        sof[0]    <= 1'b0;
        sol[0]    <= 1'b0;
        eof       <= 1'b0;
        eol       <= 1'b0;
      end

      sof[ 9: 1] <= sof[ 8: 0];
      sol[ 9: 1] <= sol[ 8: 0];
    end
  end

  // Output Assignment
  always @ (posedge clk)
  begin
    if (reset)
      wren    <= 1'b0;
    else if (sof[8] || sol[8])
      wren    <= 1'b1;
    else if (eof || eol)
      wren    <= 1'b0;
  end

  assign        wdat[12]    = wren;
  assign        wdat[11]    = sof[9];
  assign        wdat[10]    = eof | eol;
  assign        wdat[ 9: 0] = rdat_sr[89:80];

  endmodule
