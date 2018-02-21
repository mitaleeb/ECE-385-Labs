module testbench ();
	
	// Set the time unit for the clock cycles
	timeunit 10ns;
	timeprecision 1ns;
	
	// The input parameters of the top-level module
	logic Clk = 0; 
	logic Reset, Run, Continue; 
	logic[15:0] S;

	// The output parameters of the top-level module
	logic[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	logic [11:0] LED;
	logic CE, UB, LB, OE, WE;
	logic[19:0] ADDR;
	wire[15:0] Data;
	
	logic[15:0] MAR, MDR, IR, PC;
	
	// Some variables to store the expected results
	//logic[7:0] ansA1, ansB1, ansA2, ansA3, ansB2, ansB3;
	//logic ansX1, ansX2, ansX3;
	
	// to store the error count
	integer ErrorCnt = 0;
	
	always begin : CLOCK_GEN
		#1 Clk=~Clk;
	end
	
	initial begin : CLOCK_INIT
		Clk = 0;
	end
	
	lab6_toplevel lc3_processor(.*);
	assign PC = lc3_processor.my_slc.PC;
	assign MAR = lc3_processor.my_slc.MAR;
	assign MDR = lc3_processor.my_slc.MDR;
	assign IR = lc3_processor.my_slc.IR;
	
	
	initial begin : TESTS
		// Remember button inputs are ACTIVE LOW
		
		Reset = 0;
		Run = 1;
		Continue = 1;
		
		// Test case 1
		#2 Reset = 1;
		#2 Run = 0;
		#50 Run = 0;
			if (IR != 16'h5020)
				ErrorCnt++;
			
		// Test case 2
		#2 S = 16'b0;
		#2 Continue = 0;
		#2 Continue = 1;
		#50 
			if (IR != 16'h623F)
				ErrorCnt++;
		
		
		
		// Check the number of errors and print
		if (ErrorCnt == 0)
			$display("Success!");
		else
			$display("%d error(s) detected.", ErrorCnt);
	end
endmodule