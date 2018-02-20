module datapath(
	// Do we need reset?
	input logic Reset_ah, Clk, 
	
	// Tristate Buffers
	input logic GatePC, GateMDR, GateALU, GateMARMUX, 
	
	// Inputs for where the data goes from data bus
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, 
	input logic LD_REG, LD_PC, LD_LED, 
	
	// MUX inputs
	input logic[1:0] ALUK, PCMUX, ADDR2MUX, 
	input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX, 
	
	// Memory inputs
	input logic MIO_EN, 
	
	// input registers
	input logic[15:0] IR, MAR, MDR, MDR_In, PC, 
	output logic [15:0] IR_out, MAR_out, MDR_out, PC_out
);
	
	logic[15:0] d_bus;
	
	logic[15:0] IR_next, MAR_next, MDR_next, PC_next;
	
	always_ff @ (posedge Clk) begin
		IR_out <= IR_next;
		MAR_out <= MAR_next;
		MDR_out <= MDR_next;
		PC_out <= PC_next;
	end
	
	// Loading onto d_bus
	always_comb
	begin
		if (GatePC)
			d_bus = PC;
		else if (GateMDR)
			d_bus = MDR;
		else
			d_bus = 0;
	end 
	
	// Loading into our values
	always_comb
	begin
		PC_next = PC;
		MAR_next = MAR;
		IR_next = IR;
		MDR_next = MDR;
	
	
		if (LD_MAR)
			MAR_next = d_bus;
			
		if (LD_IR)
			IR_next = d_bus;
		
		if (LD_PC)
			if (PCMUX == 0)
				PC_next = PC + 1;
			else if (PC == 2) 
				PC_next = d_bus;
		
		if (LD_MDR)
			if (MIO_EN)
				MDR_next = MDR_In;
			else
				MDR_next = d_bus;
		
		
	end
	


endmodule 