module datapath(
	// Do we need reset?
	input logic Reset_ah, 
	
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
		PC_out = PC;
		MAR_out = MAR;
		IR_out = IR;
		MDR_out = MDR;
	
	
		if (LD_MAR)
			MAR_out = d_bus;
			
		if (LD_IR)
			IR_out = d_bus;
		
		if (LD_PC)
			if (PCMUX == 0)
				PC_out = PC + 1;
			else if (PC == 2) 
				PC_out = d_bus;
		
		if (LD_MDR)
			if (MIO_EN)
				MDR_out = MDR_In;
			else
				MDR_out = d_bus;
		
		
	end
	


endmodule 