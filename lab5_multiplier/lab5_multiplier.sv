module lab5_multiplier(
	input logic Clk, 
	input logic Reset, 
	input logic ClearA_LoadB, 
	input logic Run, 
	input logic[7:0] S, 
	// outputs
	output logic[7:0] Aval, 
	output logic[7:0] Bval, 
	output logic X, 
	// Hex drivers
	output logic[6:0] AhexL,
	output logic[6:0] AhexU, 
	output logic[6:0] BhexL,
	output logic[6:0] BhexU,
	output logic [6:0] counter_out);
	// Declare internal registers
	logic[7:0] A;
	logic[7:0] B;
	
	// remove this if suddenly broken
	assign Aval = A;
	assign Bval = B;
	
	//logic X_comb;
	
	// Multiplier code goes here
	// Behavior with the clock
	/*always_ff @(posedge Clk) begin
		
		// Remember that the buttons are ACTIVE LOW
		if (!Reset) begin
			// This means reset is pressed
			//A <= 8'h00;
			//B <= 8'h00;
			//X <= 1'b0;
			
		end else if (!ClearA_LoadB) begin
			// ClearA_LoadB is pressed
			//X <= 1'b0;
			//A <= 8'h00;
			//B <= S;
		end else begin
			// Is there anything we need to add here?
		end
		
		// Once we hit run we need to put the results in the registers
		if (!Run) begin
			// Put stuff that happens when we run here
			Aval <= A;
			Bval <= B;
			X <= X_comb;
		end
	end*/
	
	logic Reset_SH, ClearA_LoadB_SH, Run_SH;
	logic [7:0] S_sync;
	
	logic Shift, fn, LoadA, LoadB, ClrA, ClrB, M;
	logic [8:0] S_out;
	logic [7:0] A_out;
	logic X_in;
	assign A_out = S_out[7:0];
	assign X_in = S_out[8];
	assign M = B[0];
	reg[3:0] cnt; // just to visualize on hex displays
	// Instantiate a control unit
	control control_unit(.Clk(Clk), .Reset(Reset_SH), .ClearA_LoadB(ClearA_LoadB_SH), .M(M), 
								.Run(Run_SH), .Shift(Shift), .fn(fn), .LoadA(LoadA), .LoadB(LoadB), 
								.Reset_A(ClrA), .Reset_B(ClrB), .counter(cnt));
	register_unit registers(.Clk(Clk), .ResetA(ClrA), .ResetB(ClrB), .X_in(X_in), .Ld_A(LoadA),
									.Ld_B(LoadB), .Shift_En(Shift), .D_a(A_out), .D_b(S_sync), .B_out(), 
									.A(A), .B(B), .X(X));
	ADD_SUB9 adder(.A(A), .B(S_sync), .f_n(fn), .S(S_out));
	// ...
	
	
	// Everything below this is simply to run the HEX displays
	// on the DE2 board
	
	// Instantiate Hex Drivers
/*	logic[6:0] AhexL_comb;
	logic[6:0] AhexU_comb;
	logic[6:0] BhexL_comb;
	logic[6:0] BhexU_comb;*/
	
	/* Decodes for HEX drivers and output registers
	 * Note that the hex drivers are calculated one cycle after
	 * Sum so that they have minimal interference with timing analysis.
	 * The human eye can't see this one-cycle latency so it's ok
	 */
/*	always_ff @ (posedge Clk) begin
		AhexL <= AhexL_comb;
		AhexU <= AhexU_comb;
		BhexL <= BhexL_comb;
		BhexU <= BhexU_comb;
	end*/
	
	HexDriver AhexL_inst(.In0(A[3:0]), .Out0(AhexL));
	HexDriver AhexU_inst(.In0(A[7:4]), .Out0(AhexU));
	HexDriver BhexL_inst(.In0(B[3:0]), .Out0(BhexL));
	HexDriver BhexU_inst(.In0(B[7:4]), .Out0(BhexU));
	HexDriver Bhex1_inst(.In0(cnt[3:0]), .Out0(counter_out));
	
	
	
	// Input synchronizers
	sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {Reset_SH, ClearA_LoadB_SH, Run_SH});
	sync Din_sync[7:0] (Clk, S, S_sync);
	
endmodule
