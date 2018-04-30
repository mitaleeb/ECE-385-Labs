module testbench_2 ();
	
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
		
	end
endmodule 
