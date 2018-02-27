module sext (
	input logic[15:0] IR, SR1_out, PC, 
	input logic[1:0] ADDR2MUX, 
	input logic ADDR1MUX, 
	output logic[15:0] marmux);
	
	logic[15:0] ADDR2_out, ADDR1_out;
	always_comb
	begin
		ADDR2_out = 16'b0;
		
		// ADDR2 MUX
		if (ADDR2MUX == 2'b00) begin
			ADDR2_out = 16'b0;
		end else if (ADDR2MUX == 2'b01) begin
			ADDR2_out[5:0] = IR[5:0];
			if (IR[5] == 1'b1)
				ADDR2_out[15:6] = 10'b1111111111;
		end else if (ADDR2MUX == 2'b10) begin
			ADDR2_out[8:0] = IR[8:0];
			if (IR[8] == 1'b1)
				ADDR2_out[15:9] = 7'b1111111;
		end else if (ADDR2MUX == 2'b11) begin
			ADDR2_out[10:0] = IR[10:0];
			if (IR[10] == 1'b1)
				ADDR2_out[15:11] = 5'b11111;
		end 
		
		// ADDR1 MUX
		if(ADDR1MUX) begin 
			ADDR1_out = SR1_out;
		end else begin
			ADDR1_out = PC;
		end
		
		
		//addition of two addr muxes
		marmux = ADDR1_out + ADDR2_out;
		
	end 
endmodule 