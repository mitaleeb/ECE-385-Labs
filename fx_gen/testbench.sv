module testbench();

// set the time unit for the clock cycles
timeunit 10ns;
timeprecision 1ns;

logic CLOCK_50 = 0;  
logic CLOCK2_50 = 0;

// PUSH BUTTONS
logic [3:0] KEY;

// Switches
logic [17:0] SW; 

// HEX Displays
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

// LEDs
logic [8:0] LEDG;
logic [17:0] LEDR; 

// I2C connections
logic I2C_SDAT; 
logic I2C_SCLK;

// Audio Codec Signals
wire AUD_ADCLRCK; // ADC LR Clock
logic AUD_ADCDAT; // ADC DATA
wire AUD_DACLRCK; // DAC LR Clock
logic AUD_DACDAT; // DAC DATA
wire AUD_BCLK; // Bit-Stream Clock
logic AUD_XCK; // Chip Clock

// VGA Signals
logic [7:0] VGA_R, VGA_G, VGA_B; 
logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS; 

// SRAM Signals
logic [19:0] SRAM_ADDR; 
wire [15:0] SRAM_DQ;
logic SRAM_CE_N, SRAM_OE_N, SRAM_WE_N; 
logic SRAM_UB_N, SRAM_LB_N;

always begin : CLOCK_GEN
	#1 Clk=~Clk;
end

always begin: 

initial begin : CLOCK_INIT
	Clk = 0;
end

fx_gen toplevel(.*);

initial begin : TESTS
  // Remember button inputs are ACTIVE LOW
  
  SW[4:0] = 5'b0;
  Run = 1;
  Continue = 1;
  
  // Test case 1
  
end

endmodule 