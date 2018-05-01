/**
 * Top-level entity for audio FX generator.
 *
 * ECE 385 Spring 2018 at the University of Illinois
 *
 * Dean Biskup and Mitalee Bharadwaj
 *
 * xd
 */
module fx_gen(
  // 50 MHz Clock input
  input CLOCK_50,  
  input CLOCK2_50,

  // PUSH BUTTONS
  input logic [3:0] KEY,

  // Switches
  input logic [17:0] SW, 

  // HEX Displays
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,

  // LEDs
  output [8:0] LEDG, 
  output [17:0] LEDR, 

  // I2C connections
  inout I2C_SDAT, 
  output I2C_SCLK,

  // Audio Codec Signals
  inout AUD_ADCLRCK, // ADC LR Clock
  input AUD_ADCDAT, // ADC DATA
  inout AUD_DACLRCK, // DAC LR Clock
  output AUD_DACDAT, // DAC DATA
  inout AUD_BCLK, // Bit-Stream Clock
  output AUD_XCK // Chip Clock
  );

  // Do some connections for debugging
  assign LEDR = SW;
  assign LEDG = 8'b0;

  // Local connections
  logic [3:0] filter_select;
  logic DSP_enable;
  assign DSP_enable = SW[0];
  assign filter_select = SW[4:1];

  // Some stuff to make things a little easier to type
  logic reset_h, clk;
  assign reset_h = (SW[10] & SW[9]) ? 1'b1 : 1'b0;
  assign clk = CLOCK_50;

  // Some signals to help debug
  logic[15:0] audio_R, audio_L;
  logic [15:0] register_fileL[1000];
  logic [15:0] register_fileR[1000];
  audio_controller audiocontrol(.*, .vol_up(~KEY[1]), .vol_down(~KEY[0]), 
    .DSP_outR(audio_R), .DSP_outL(audio_L));


  // Always ff block to make things readable
  int counterxd;
  logic [3:0] hi0, hi1, hi2, hi3, hi4, hi5, hi6, hi7;
  always_ff @ (posedge clk) begin 
    if (counterxd == 5000000) begin
      hi0 <= audio_R[3:0];
      hi1 <= audio_R[7:4];
      hi2 <= audio_R[11:8];
      hi3 <= audio_R[15:12];
      hi4 <= audio_L[3:0];
      hi5 <= audio_L[7:4];
      hi6 <= audio_L[11:8];
      hi7 <= audio_L[15:12];
      counterxd <= 0;
    end else begin
      hi0 <= hi0;
      hi1 <= hi1;
      hi2 <= hi2;
      hi3 <= hi3;
      hi4 <= hi4;
      hi5 <= hi5;
      hi6 <= hi6;
      hi7 <= hi7;
      counterxd <= counterxd + 1;
    end
  end

  // Hex Drivers
  HexDriver h0(.In0(hi0), .Out0(HEX0));
  HexDriver h1(.In0(hi1), .Out0(HEX1));
  HexDriver h2(.In0(hi2), .Out0(HEX2));
  HexDriver h3(.In0(hi3), .Out0(HEX3));
  HexDriver h4(.In0(hi4), .Out0(HEX4));
  HexDriver h5(.In0(hi5), .Out0(HEX5));
  HexDriver h6(.In0(hi6), .Out0(HEX6));
  HexDriver h7(.In0(hi7), .Out0(HEX7));

endmodule 