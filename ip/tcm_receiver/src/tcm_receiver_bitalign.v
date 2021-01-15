  module  tcm_receiver_bitalign
  (
    input   wire            reset,
    input   wire            clk,
    input   wire  [ 9: 0]   rdat,
    output  reg   [ 9: 0]   wdat
  );

  // Wires and Registers
  reg   [69: 0]   rdat_sr;
  reg   [ 9: 0]   pos_d1;
  reg   [ 9: 0]   pos;

  // Input Shift Register
  always @ (posedge clk)
  begin
    if (reset)
      rdat_sr   <= 70'd0;
    else
      rdat_sr   <= {rdat_sr[59: 0], rdat};
  end

  // Check position
  always @ (posedge clk)
  begin
    if (reset)
      pos_d1  <= 10'd0;
    else
    begin
      pos_d1[ 0]  <= (rdat_sr[59: 0] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 1]  <= (rdat_sr[60: 1] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 2]  <= (rdat_sr[61: 2] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 3]  <= (rdat_sr[62: 3] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 4]  <= (rdat_sr[63: 4] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 5]  <= (rdat_sr[64: 5] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 6]  <= (rdat_sr[65: 6] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 7]  <= (rdat_sr[66: 7] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 8]  <= (rdat_sr[67: 8] == 60'hFFC00FFC00FFFFF);
      pos_d1[ 9]  <= (rdat_sr[68: 9] == 60'hFFC00FFC00FFFFF);
    end
  end

  always @ (posedge clk)
  begin
    if (reset)
      pos   <= 10'd0;
    else if (pos_d1 != 10'd0)
      pos   <= pos_d1;
  end

  // Muxing Output Bit Position
  always @ (posedge clk)
  begin
    if (reset)
      wdat    <= 10'd0;
    else
    begin
      case (pos)
      10'b0000000001: wdat  <= rdat_sr[59:50];
      10'b0000000010: wdat  <= rdat_sr[60:51];
      10'b0000000100: wdat  <= rdat_sr[61:52];
      10'b0000001000: wdat  <= rdat_sr[62:53];
      10'b0000010000: wdat  <= rdat_sr[63:54];
      10'b0000100000: wdat  <= rdat_sr[64:55];
      10'b0001000000: wdat  <= rdat_sr[65:56];
      10'b0010000000: wdat  <= rdat_sr[66:57];
      10'b0100000000: wdat  <= rdat_sr[67:58];
      10'b1000000000: wdat  <= rdat_sr[68:59];
      default:        wdat  <= rdat_sr[59:50];
      endcase
    end
  end

  endmodule