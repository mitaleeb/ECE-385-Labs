module reg_file(
	input logic Clk, Reset_ah, LD_REG, 
	input logic [2:0] SR2, 
	input logic [2:0] DR_MUX_out, SR1_MUX_out, 
	input logic [15:0] d_bus, 
	output logic [15:0] SR1_out, SR2_out);
	
	// Create 'registers' for each register
	logic[15:0] R1, R2, R3, R4, R5, R6, R7, R0;
	
	always_ff @ (posedge Clk)
	begin
		if (Reset_ah) begin
			R0 = 16'h0000;
			R1 = 16'h0000;
			R2 = 16'h0000;
			R3 = 16'h0000;
			R4 = 16'h0000;
			R5 = 16'h0000;
			R6 = 16'h0000;
			R7 = 16'h0000;
		end else if (LD_REG) begin
			if (DR_MUX_out == 3'b000)
				R0 <= d_bus;
			else if (DR_MUX_out == 3'b001)
				R1 <= d_bus;
			else if (DR_MUX_out == 3'b010)
				R2 <= d_bus;
			else if (DR_MUX_out == 3'b011)
				R3 <= d_bus;
			else if (DR_MUX_out == 3'b100)
				R4 <= d_bus;
			else if (DR_MUX_out == 3'b101)
				R5 <= d_bus;
			else if (DR_MUX_out == 3'b110)
				R6 <= d_bus;
			else if (DR_MUX_out == 3'b111)
				R7 <= d_bus;
		end
		
		// Check SR1 and SR2 to set output
		if (SR2 == 3'b000)
			SR2_out <= R0;
		else if (SR2 == 3'b001)
			SR2_out <= R1;
		else if (SR2 == 3'b010)
			SR2_out <= R2;
		else if (SR2 == 3'b011)
			SR2_out <= R3;
		else if (SR2 == 3'b100)
			SR2_out <= R4;
		else if (SR2 == 3'b101)
			SR2_out <= R5;
		else if (SR2 == 3'b110)
			SR2_out <= R6;
		else if (SR2 == 3'b111)
			SR2_out <= R7;
			
		if (SR1_MUX_out == 3'b000)
			SR1_out <= R0;
		else if (SR1_MUX_out == 3'b001)
			SR1_out <= R1;
		else if (SR1_MUX_out == 3'b010)
			SR1_out <= R2;
		else if (SR1_MUX_out == 3'b011)
			SR1_out <= R3;
		else if (SR1_MUX_out == 3'b100)
			SR1_out <= R4;
		else if (SR1_MUX_out == 3'b101)
			SR1_out <= R5;
		else if (SR1_MUX_out == 3'b110)
			SR1_out <= R6;
		else if (SR1_MUX_out == 3'b111)
			SR1_out <= R7;
	end
endmodule  