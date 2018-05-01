/**
 * audio modifier module that serves as the median level module that handles the inputs
 * to the various different modifications available
 *
 * By Dean Biskup and Mitalee Bharadwaj
 */
module audio_modifier(
  input CLOCK_50, reset_h, 
  input AUD_DACLRCK, 
  input logic [15:0] audio_inR, audio_inL, 
  output logic [15:0] DSP_outR, DSP_outL, 
  input logic vol_up, vol_down, 
  input logic [3:0] filter_select, // Selects the filters to be active
  output logic dsp_done, 
  
  // For reverb and visualization
  output logic [15:0] register_fileL[64], 
  output logic [15:0] register_fileR[64]
);

int volume_scale;
logic [15:0] audio_R, audio_L; 

// DEBUG
//assign audio_R = audio_inR;
//assign audio_L = audio_inL;
assign dsp_done = AUD_DACLRCK;

// Register file to hold the past 64 samples
pastsignals audioROMR(.AUD_DACLRCK(AUD_DACLRCK), .clk(CLOCK_50), .reset_h(reset_h), 
  .register_file(register_fileR), .index(), .read(0), .sample_in(DSP_outR));
pastsignals audioROML(.AUD_DACLRCK(AUD_DACLRCK), .clk(CLOCK_50), .reset_h(reset_h), 
  .register_file(register_fileL), .index(), .read(0), .sample_in(DSP_outL));

always_ff @ (posedge CLOCK_50) begin
  DSP_outR <= audio_R * volume_scale;
  DSP_outL <= audio_L * volume_scale;
end

logic [15:0] lpf_outL, lpf_outR;
lowpassfilter lpf(.*, .lpf_outputR(lpf_outR), .lpf_outputL(lpf_outL));

logic [15:0] audio_R_n, audio_L_n;
always_ff @ (posedge CLOCK_50) begin
  audio_L <= audio_L_n;
  audio_R <= audio_R_n;
end

always_comb begin
  audio_R_n = audio_inR;
  audio_L_n = audio_inL;

  // Check the filter selections to decide the next out signal
  if (filter_select[0]) begin
    // LPF
    audio_L_n = lpf_outL;
    audio_R_n = lpf_outR;
  end
end 

///////////// Volume Control ////////////
enum logic [4:0] {Increase, Increase_s, Decrease_s, Decrease, Idle} vol_state, vol_state_next;
int vol_scale_n;
always_ff @ (posedge CLOCK_50) begin
  vol_state <= vol_state_next;
  volume_scale <= vol_scale_n;
end

always_comb begin
  vol_state_next = vol_state;
  vol_scale_n = volume_scale;
  unique case (vol_state)
  Idle: begin
    if (vol_down) begin
      vol_state_next = Decrease;
    end else if (vol_up) begin
      vol_state_next = Increase;
    end else begin
      vol_state_next = Idle;
    end
  end
  Increase: begin
    if (volume_scale == 0)
      vol_scale_n = 1;
    else if (volume_scale < 8)
      vol_scale_n = volume_scale * 2;
    vol_state_next = Increase_s;
  end
  Increase_s: begin 
    if (~vol_up)
      vol_state_next = Idle;
  end
  Decrease: begin
    vol_scale_n = volume_scale / 2;
    vol_state_next = Decrease_s;
  end
  Decrease_s: begin
    if (~vol_down)
      vol_state_next = Idle;
  end
  endcase
end
///////////// End Volume Control //////////

endmodule
