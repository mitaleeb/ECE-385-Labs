module ALU (
	input logic[15:0] SR2_out, SR1_out,
	input logic[4:0] IR_40, 
	input logic[1:0] ALUK, 
	input logic SR2MUX, 
	output logic[15:0] ALU_out);
	
	logic[15:0] sext, SR2_MUX_out;
	
	// Mux logic for SR2MUX 
	always_comb 
	begin
		// Perform sign extension on imm5
		sext[4:0] = IR_40;
		sext[15:5] = 11'b0;
		if (IR_40[4] == 1)
			sext[15:5] = 11'b11111111111;
		
		// Set the output of SR2MUX
		if (SR2MUX) // Note that SR2MUX is equivalent to IR[5]
			SR2_MUX_out = sext;
		else
			SR2_MUX_out = SR1_out;
	end 
	
	// Arithmetic Logic Unit Logic
	always_comb
	begin
		// 00 add, 01 and, 10 not, 11 passA
		// Are the ALUK signals for ALU
		if (ALUK == 2'b00) begin
			ALU_out = SR2_MUX_out + SR1_out;
		end else if (ALUK == 2'b01) begin
			ALU_out = SR2_MUX_out & SR1_out;
		end else if (ALUK == 2'b10) begin
			ALU_out = ~SR1_out;
		end else begin
			ALU_out = SR1_out;
		end 
	end
endmodule 
		
		