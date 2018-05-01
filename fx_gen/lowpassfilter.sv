/**
 * Implementation of a low pass filter
 *
 * @author Dean Biskup and Mitalee Bharadwaj
 */

module lowpassfilter(
  input CLOCK_50, AUD_DACLRCK, 
  input logic [15:0] audio_inR,
  input logic [15:0] audio_inL, // 16-bit audio input
  output logic [15:0] lpf_outputR, lpf_outputL
);

  // Control signals for the biquad filters
  logic new_sample, new_coefficients;
  logic signed [17:0] a0, a1, a2, b1, b2;

  // DEBUG
  // We'll try using fixed point representation, fp: 4.4 for now
//  logic signed [7:0] a_test0;
//  assign a_test0 = ~(8'b10000011)+1;

//  fp_mult fpL(.sample(audio_inL), .coefficient(a_test0), .fp_out(lpf_outputL));
//  fp_mult fpR(.sample(audio_inR), .coefficient(a_test0), .fp_out(lpf_outputR));
  
  
  // Divide the floating point areas by 16384 which is 10000.
  // so the math would be x/10000 = y/16384
  assign a0 = 18'b000000000001000000;
  assign a1 = 18'b000000000010000000;
  assign a2 = 18'b000000000001000000;
  assign b1 = -1024;
  assign b2 = 18'b000011010100101111;
  
  

  // Instantiate biquads for both the left and the right sides
  biquad left(.CLOCK_50(CLOCK_50), .Reset(0), .new_sample(new_sample), 
    .new_coefficients(new_coefficients), .sample_in(audio_inL), .a0_load(a0), 
    .a1_load(a1), .a2_load(a2), .b1_load(b1), .b2_load(b2), .sample_out(lpf_outputL));
  biquad right(.CLOCK_50(CLOCK_50), .Reset(0), .new_sample(new_sample), 
    .new_coefficients(new_coefficients), .sample_in(audio_inR), .a0_load(a0), 
    .a1_load(a1), .a2_load(a2), .b1_load(b1), .b2_load(b2), .sample_out(lpf_outputR));
  
  // Testing this
  assign new_sample = AUD_DACLRCK;
  assign new_coefficients = 1;

  enum logic [5:0] {HALT} next_state, state;

endmodule // lowpassfilter