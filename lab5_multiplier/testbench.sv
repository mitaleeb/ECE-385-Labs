module testbench ();
	
	// Set the time unit for the clock cycles
	timeunit 10ns;
	timeprecision 1ns;
	
	// The input parameters of the top-level module
	logic Clk = 0; 
	logic Reset, ClearA_LoadB, Run;
	logic[7:0] S;

	// The output parameters of the top-level module
	logic[7:0] Aval;
	logic[7:0] Bval;
	logic X;
	logic[6:0] AhexL, AhexU, BhexL, BhexU;
	logic [6:0] counter_out;
	
	
	// Some variables to store the expected results
	logic[7:0] ansA1, ansB1, ansA2, ansA3, ansA4, ansB2, ansB3, ansB4;
	logic ansX1, ansX2, ansX3, ansX4;
	
	// to store the error count
	integer ErrorCnt = 0;
	
	always begin : CLOCK_GEN
		#1 Clk=~Clk;
	end
	
	initial begin : CLOCK_INIT
		Clk = 0;
	end
	
	lab5_multiplier mult(.*);
	
	initial begin : TESTS
		// Remember button inputs are ACTIVE LOW
		Reset = 0;
		ClearA_LoadB = 1;
		Run = 1;
		
		// test case 1
		#2 Reset = 1;
		#2 S = 8'h01;
		#2 ClearA_LoadB = 0;
		#2 ClearA_LoadB = 1;
		#2 S = 8'h08;
		#2 Run = 0; // executes
		
		#60 ansA1 = 8'h00;
			 ansB1 = 8'h08;
			 ansX1 = 0;
			 if (Aval != ansA1)
				ErrorCnt++;
			 if (Bval != ansB1)
				ErrorCnt++;
			 if (X != ansX1)
				ErrorCnt++;
			 Run = 1;
			 
		// Test case 2
		#2 S = 8'h01;
		#2 ClearA_LoadB = 0;
		#2 ClearA_LoadB = 1;
		#2 S = 8'hFF;
		#2 Run = 0;
		
		#60 ansA2 = 8'hFF;
			ansB2 = 8'hFF;
			ansX2 = 1;
			if (Aval != ansA2)
				ErrorCnt++;
			if (Bval != ansB2)
				ErrorCnt++;
			if (X != ansX2)
				ErrorCnt++;
			Run = 1;
			
		// Test case 3	
		#2 S = 8'hFE; // -2
		#2 Run = 0;
		
		#60 ansA3 = 8'h00;
			ansB3 = 8'h02;
			ansX3 = 0;
			if (Aval != ansA3)
				ErrorCnt++;
			if (Bval != ansB3)
				ErrorCnt++;
			if (X != ansX3)
				ErrorCnt++;
			Run = 1;
			
		
		// Test case 4
		#2 S = 8'h7F; // 16
		#2 Run = 0;
		
		#60 ansA4 = 8'h00;
			ansB4 = 8'hFE;
			ansX4 = 0;
			if (Aval != ansA4)
				ErrorCnt++;
			if (Bval != ansB4)
				ErrorCnt++;
			if (X != ansX4)
				ErrorCnt++;
			Run = 1;
			
		// Check the number of errors and print
		if (ErrorCnt == 0)
			$display("Success!");
		else
			$display("%d error(s) detected.", ErrorCnt);
	end
endmodule
