module testbench();

	timeunit 10ns;
	timeprecision 1ns;
	
	logic           Clk;        // 50MHz clock is only used to get timing estimate data
	logic           Reset;      // From push-button 0.  Remember the button is active low (0 when pressed)
	logic           LoadB;      // From push-button 1
	logic           Run;        // From push-button 3.
	logic[15:0]     SW;         // From slider switches
	 
	// all outputs are registered
	logic           CO;         // Carry-out.  Goes to the green LED to the left of the hex displays.
	logic[15:0]     Sum;        // Goes to the red LEDs.  You need to press "Run" before the sum shows up here.
	logic[6:0]      Ahex0;      // Hex drivers display both inputs to the adder.
	logic[6:0]      Ahex1;
	logic[6:0]      Ahex2;
	logic[6:0]      Ahex3;
	logic[6:0]      Bhex0;
	logic[6:0]      Bhex1;
	logic[6:0]      Bhex2;
	logic[6:0]      Bhex3;
	
	always begin : CLOCK_GENERATION
	
		#1 Clk=~Clk;
	
	end
	
	initial begin : CLOCK_INIT
		Clk = 0;
	end
	
	lab4_adders_toplevel tp(.*);
	
	initial begin: TESTS
		Reset = 0;
		LoadB = 1;
		Run = 1;
		
		// test case 1
		#2 Reset = 1;
		#2 LoadB = 0;
			SW = 16'h0001;
		#2 LoadB = 1;
			SW = 16'h0002;
		#2 Run = 0;
		
		#6 Run = 1;
		#4 LoadB = 0;
			SW = 16'h0022;
		#2 LoadB = 1;
			SW = 16'h0022;
		#2 Run = 0;
		#10;
		
	end

endmodule
