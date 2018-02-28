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
	
	logic[15:0] MAR, MDR, IR, PC, R0, R1, R2, R5;
	logic[3:0] hex0, hex1, hex2, hex3;
	logic n, z, p, BEN;
	
	// Some variables to store the expected results
	//logic[7:0] ansA1, ansB1, ansA2, ansA3, ansB2, ansB3;
	//logic ansX1, ansX2, ansX3;
	
	// to store the error count
	integer TestCase = 1;
	
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
	assign hex0 = lc3_processor.my_slc.hex_4[0][3:0];
	assign hex1 = lc3_processor.my_slc.hex_4[1][3:0];
	assign hex2 = lc3_processor.my_slc.hex_4[2][3:0];
	assign hex3 = lc3_processor.my_slc.hex_4[3][3:0];
	assign R0 = lc3_processor.my_slc.reg_unit.R0;
	assign R1 = lc3_processor.my_slc.reg_unit.R1;
	assign R2 = lc3_processor.my_slc.reg_unit.R2;
	assign R5 = lc3_processor.my_slc.reg_unit.R5;
	assign n = lc3_processor.my_slc.d0.n;
	assign z = lc3_processor.my_slc.d0.z;
	assign p = lc3_processor.my_slc.d0.p;
	assign BEN = lc3_processor.my_slc.BEN;
	
	
	initial begin : TESTS
		// Remember button inputs are ACTIVE LOW
		
		Reset = 0;
		Run = 1;
		Continue = 1;
		
		// Test case 1
		// Load basic I/O 1
		#2 Reset = 1;
			S = 3;
		#2 Run = 0;
		#100 S = 10;
		#100 S = 17;
		#100 Run = 1;
			Reset = 0;
			TestCase++;
		
		// Test case 2
		// Load basic I/O 2
		#2 Reset = 1;
			S = 6;
		#2 Run = 0;
		#100 Continue = 0;
		#2 Continue = 1;
		#100 Continue = 0;
		#2 S = 16;
			Continue = 1;
		#100 S = 20;
		#100 Continue = 0;
		#2 Continue = 1;
		#100 Run = 1;
			Reset = 0;
			TestCase++;
		// Test case 3
		// Self-modifying code test
		#2 Reset = 1;
			S = 16'h000B;
		#2 Run = 0;
		#100 S = 16'hD000;
			Continue = 0;
		#2 Continue = 1;
		#100 S = 16'hD001;
			Continue = 0;
		#2 Continue = 1;
		#100 Run = 1;
			Reset = 0;
			TestCase++;
		
		// Test case 4
		// XOR Test
		#2 Reset = 1;
			S = 16'h0014;
		#2 Run = 0;
		#100 S = 16'h1001;
			Continue = 0;
		#2 Continue = 1;
		#100 S = 16'h0000;
		#100 Continue = 0;
		#2 Continue = 1;
		#300 Run = 1;
			Reset = 0;
			TestCase++;
			
		// Test case 5
		// Multiplication Test
		#2 Reset = 1;
			S = 16'h0031;
		#2 Run = 0;
		#300 S = 16'h0007;
			Continue = 0;
		#2 Continue = 1;
		#100 S = 16'hFFC5;
		#500 Continue = 0;
		#2 Continue = 1;
		#2000 Run = 1;
			Reset = 0;
			TestCase++;
		
		// Test case 6
		// Sorting Function
		#2 Reset = 1;
			S = 16'h005A;
		#2 Run = 0;
		#300 S = 16'h0002; // Call sort
			Continue = 0;
		#2 Continue = 1;
		#25000 S = 16'h0003; // Call display
			Continue = 0;
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 1
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 2
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 3
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 4
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 5
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 6
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 7
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 8
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 9
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 10
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 11
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 12 
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 13
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 14
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 15
		#2 Continue = 1;
		#300 Continue = 0;; // continue display 16
		#2 Continue = 1;
	
		
		#3000 Run = 1;
			Reset = 0;
			TestCase++;
		

		
		// Check the number of errors and print
		if (TestCase == 0)
			$display("Success!");
		else
			$display("Ran %d test cases", TestCase);
	end
endmodule