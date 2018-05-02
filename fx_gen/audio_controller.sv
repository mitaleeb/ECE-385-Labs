module audio_controller(
  input clk, reset_h, DSP_enable, 

  // Audio signals
  input AUD_ADCDAT, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, 
  output logic AUD_DACDAT, AUD_XCK, 

  // i2c signals
  output logic I2C_SCLK, I2C_SDAT, 

  // Output signals for debugging
  output logic [15:0] DSP_outR, DSP_outL, 
  
  // Filter select input, volume buttons inputs
  input logic vol_up, vol_down, 
  input logic [3:0] filter_select, 
  
  // For visualization
  output logic [15:0] register_fileL[32], 
  output logic [15:0] register_fileR[32]
  );

// local registers holding the intermediate audio signals
logic [15:0] audio_outL, audio_outR, audio_outL_next, audio_outR_next;
logic [15:0] audio_R, audio_L;
logic [15:0] audio_L_next, audio_R_next;

// DSP signals
logic new_sample, dsp_done;

// This one seems to be needed for the audio interface
logic [31:0] ADCDATA;
logic INIT, INIT_FINISH, ADC_FULL, DATA_OVER;

// State machine states
enum logic [3:0] {RESET, INITIALIZE, AUD_IN, PROCESSING, 
  LOAD_OUT, ADC_DAC} state, next_state;

// Initialize the audio interface
audio_interface audiointerface(.clk(clk), .INIT(INIT), 
  .INIT_FINISH(INIT_FINISH), .AUD_MCLK(AUD_XCK), .AUD_BCLK(AUD_BCLK), 
  .AUD_DACDAT(AUD_DACDAT), .AUD_ADCDAT(AUD_ADCDAT), .AUD_DACLRCK(AUD_DACLRCK), 
  .AUD_ADCLRCK(AUD_ADCLRCK), .I2C_SDAT(I2C_SDAT), .I2C_SCLK(I2C_SCLK), 
  .LDATA(audio_outL), .RDATA(audio_outR), 
  .Reset(reset_h), .data_over(DATA_OVER), .adc_full(ADC_FULL), .ADCDATA(ADCDATA));
  
// audio_modifier instance
audio_modifier amod(.*, .CLOCK_50(clk), .AUD_DACLRCK(AUD_DACLRCK), 
  .audio_inR(audio_R), .audio_inL(audio_L), .DSP_outR(DSP_outR), .DSP_outL(DSP_outL), 
  .vol_up(vol_up), .vol_down(vol_down), .filter_select(filter_select), 
  .dsp_done(dsp_done));


// State machine for audio control
always_ff @ (posedge clk) begin
  if (reset_h)
    state <= RESET;
  else begin
    state <= next_state;
    audio_outL <= audio_outL_next;
    audio_outR <= audio_outR_next;
    audio_L <= audio_L_next;
    audio_R <= audio_R_next;
  end
end

always_comb begin
  // Next state logic
  next_state = state;
  case (state) 
    RESET: next_state = INITIALIZE;
    INITIALIZE: begin
      if (INIT_FINISH)
        next_state = AUD_IN;
    end // INITIALIZE:
    AUD_IN: begin
      if (DATA_OVER) begin
        if (DSP_enable)
          next_state = PROCESSING;
        else next_state = ADC_DAC;
      end
    end // AUD_IN:
    PROCESSING: begin
      if (dsp_done)
        next_state = LOAD_OUT;
    end // PROCESSING:
    LOAD_OUT: begin
      if (~DATA_OVER)
        next_state = AUD_IN;
    end // LOAD_OUT:
    ADC_DAC: begin
      if (~DATA_OVER) 
        next_state = AUD_IN;
    end // ADC_DAC:
    default: ;
  endcase // state

  // Control signals for each state
  INIT = 0;
  new_sample = 0;
  audio_outR_next = audio_outR;
  audio_outL_next = audio_outL;
  audio_R_next = audio_R;
  audio_L_next = audio_L;

  case (state) 
    INITIALIZE: INIT = 1;
    AUD_IN: begin
      audio_L_next = ADCDATA[31:16];
      audio_R_next = ADCDATA[15:0];
    end // AUD_IN:
    PROCESSING: begin
      new_sample = 1;
    end // PROCESSING:
    LOAD_OUT: begin
      new_sample = 1;
      audio_outL_next = DSP_outL;
      audio_outR_next = DSP_outR;
    end // LOAD_OUT:
    ADC_DAC: begin
		// This part is pure replaying
      new_sample = 1;
      audio_outR_next = audio_R;
      audio_outL_next = audio_L;
    end
    default: ;
  endcase // state
end // always_comb


endmodule 