// This module controls the control unit logic 
// in the multiplier. 
module control
(
	input logic Clk, Reset, ClearA_LoadB, Run, M, 
	output logic Shift, fn, LoadA, LoadB, Reset_A, Reset_B, 	
	output reg[3:0] counter
);

	// Define the states
	enum logic[2:0] {idle_state, load_state, add_state, shift_state, decision_state, halt_state} 
		curr_state, next_state;
	
	// Counter
	reg[3:0] next_counter;
	
	//fn bit
	logic next_fn;
	
	// updates flip-flop
	always_ff @ (posedge Clk) begin
		counter <= next_counter;
		fn <= next_fn;
		if (Reset)
			curr_state <= idle_state;
		else
			curr_state <= next_state;
	end
	
	// Next state logic
	always_comb begin
		// Need to initialize default values
		Shift = 1'b0;
		next_fn = fn;
		LoadA = 1'b0;
		LoadB = 1'b0;
		Reset_A = 1'b0;
		Reset_B = 1'b0;
		//counter = 4'b0;
		next_counter = counter;
		
		next_state = curr_state;
		
		unique case (curr_state)
			idle_state: 
				if (Run)
					next_state = decision_state;
				else
					next_state = idle_state;
			decision_state:
				if (counter == 4'd8)
					next_state = halt_state;
				else if (M)
					next_state = add_state;
				else
					next_state = shift_state;
			shift_state: next_state = decision_state;
			add_state: next_state = shift_state;
			halt_state:
				if (~Run)
					next_state = idle_state;
			
		endcase
		
		// Assign the actual outputs based on state
		case (curr_state)
			idle_state: begin
				// Put stuff here
				next_counter = 4'b0;
				Shift = 1'b0;
				next_fn = 1'b0;
				if (ClearA_LoadB) begin
					Reset_A = 1'b1;
					LoadB = 1'b1;
				end else if (Reset) begin
					Reset_A = 1'b1;
					Reset_B = 1'b1;
				end else if (Run) begin 
					Reset_A = 1'b1;
				end else begin
					Reset_A = 1'b0;
					Reset_B = 1'b0;
					LoadA = 1'b0;
					LoadB = 1'b0;
				end
			end
			decision_state: begin
				LoadA = 1'b0;
				if (counter == 4'd7) begin
					if (M) begin
						next_fn = 1'b1;
					end
				end
				else
					next_fn = 1'b0;
			end
			shift_state: begin
				// Put stuff here
				Shift = 1'b1;
				next_counter = counter + 4'b1;
			end
			add_state: begin
				// Stuff
				LoadA = 1'b1;
			end
		endcase
	end
endmodule 