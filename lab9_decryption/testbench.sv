module testbench();

	// Set the time unit for the clock cycles
	timeunit 10ns;
	timeprecision 1ns;
	
	// The input parameters of the top-level module
	logic CLK;
	logic RESET;
	logic AES_START;
	logic AES_DONE, hardware_write, running;
	logic [127:0] AES_KEY;
	logic [127:0] AES_MSG_ENC;
	logic [127:0] AES_MSG_DEC;
	
	// Generate the clock
	always begin : CLOCK_GEN
		#1 CLK = ~CLK;
	end
	
	initial begin : CLOCK_INIT
		CLK = 0;
	end
	
	logic [127:0] state;
	AES aes(.*);
	
	assign state = aes.state;
	
	initial begin : TESTS
		// Set AES_KEY, AES_MSG_ENC
		
		AES_KEY = 128'h000102030405060708090a0b0c0d0e0f;
		AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
		
		#1 RESET = 1;
		#20 RESET = 0;
		#1 AES_START = 1;
		
	end
	

endmodule 