module reg_16(
	input logic Clk, Reset_ah, Load, 
	input logic[15:0] D_in, 
	output logic [7:0] Data_out);
	
	always_ff @ (posedge Clk)
	begin
		if (Reset_ah) // reset everything to 0
			Data_out = 16'h0000;
		else if (Load)
			Data_out <= D_in;
	end
	
endmodule 