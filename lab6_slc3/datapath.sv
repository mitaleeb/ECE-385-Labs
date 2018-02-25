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
	input logic[15:0] IR, MAR, MDR, MDR_In, PC, d_bus, 
	input logic n, z, p, BEN, 
	output logic [15:0] IR_out, MAR_out, MDR_out, PC_out, 
	output logic n_out, z_out, p_out, BEN_out, 
	output logic [2:0] SR1_MUX_out, DR_MUX_out
);
	
	//logic[15:0] d_bus;
	
	logic[15:0] IR_next, MAR_next, MDR_next, PC_next;
	logic n_next, z_next, p_next, BEN_next;
	
	// Assignments for the mux
	
	always_ff @ (posedge Clk) begin
		IR_out <= IR_next;
		MAR_out <= MAR_next;
		MDR_out <= MDR_next;
		PC_out <= PC_next;
		n_out <= n_next;
		z_out <= z_next;
		p_out <= p_next;
		BEN_out = BEN_next;
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
		n_next = n;
		z_next = z;
		p_next = p;
		BEN_next = BEN;
		
		if (Reset_ah) begin
			PC_next = 0;
			MAR_next = 0;
			IR_next = 0;
			MDR_next = 0;
		end
	
		if (LD_MAR)
			MAR_next = d_bus;
			
		if (LD_IR)
			IR_next = d_bus;
		
		if (LD_PC)
			if (PCMUX == 0)
				PC_next = PC + 1;
			else if (PC == 2) 
				PC_next = d_bus;
		
		if (LD_BEN)
			BEN_next = (IR[11] & n) | (IR[10] & z) | (IR[9] & p);
		
		if (LD_MDR)
			if (MIO_EN)
				MDR_next = MDR_In;
			else
				MDR_next = d_bus;
		
		
	end
	


endmodule 