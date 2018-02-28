module datapath(
	// Do we need reset?
	input logic Reset_ah, Clk, 
	
	// Tristate Buffers
	input logic GatePC, GateMDR, GateALU, GateMARMUX, 
	
	// Inputs for where the data goes from data bus
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, 
	input logic LD_REG, LD_PC, LD_LED, 
	
	// MUX inputs
	input logic[1:0] PCMUX, 
	input logic DRMUX, SR1MUX, 
	
	// Memory inputs
	input logic MIO_EN, 
	
	// input registers
	input logic[15:0] IR, MAR, MDR, MDR_In, PC, marmux, ALU_out, 
	input logic[11:0] LED, 
	input logic BEN, 
	output logic [15:0] IR_out, MAR_out, MDR_out, PC_out, d_bus, 
	output logic[11:0] LED_out, 
	output logic BEN_out, 
	output logic [2:0] SR1_MUX_out, DR_MUX_out
);
	
	//logic[15:0] d_bus;
	
	logic[15:0] IR_next, MAR_next, MDR_next, PC_next, d_bus_next;
	logic[11:0] LED_next;
	logic n_next, z_next, p_next, BEN_next;
	logic n, z, p;
	logic[11:0] ledVect;
	assign ledVect = IR[11:0];
	assign d_bus_next = d_bus;
	
	// Assignments for the mux
	always_comb
	begin
		if (DRMUX == 1)
			DR_MUX_out = 3'b111;
		else
			DR_MUX_out = IR[11:9];
		
		if (SR1MUX == 1)
			SR1_MUX_out = IR[11:9];
		else
			SR1_MUX_out = IR[8:6];
	end
	
	always_ff @ (posedge Clk) begin
		if (Reset_ah) begin
			IR_out <= 0;
			MAR_out <= 0;
			MDR_out <= 0;
			PC_out <= 0;
			n <= 0;
			z <= 0;
			p <= 0;
			BEN_out <= 0;
			LED_out <= 0;
		end else begin
			IR_out <= IR_next;
			MAR_out <= MAR_next;
			MDR_out <= MDR_next;
			PC_out <= PC_next;
			n <= n_next;
			z <= z_next;
			p <= p_next;
			BEN_out <= BEN_next;
			LED_out <= LED_next;
		end
	end
	
	// Loading onto d_bus
	always_comb
	begin
		d_bus = d_bus_next;
		if (GatePC)
			d_bus = PC;
		else if (GateMDR)
			d_bus = MDR;
		else if (GateMARMUX)
			d_bus = marmux;
		else if (GateALU)
			d_bus = ALU_out;
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
		LED_next = LED;
		
		if (LD_MAR)
			MAR_next = d_bus;
			
		if (LD_IR)
			IR_next = d_bus;
		
		if (LD_CC) begin
			if (d_bus == 0) begin
				z_next = 1'b1;
				n_next = 1'b0;
				p_next = 1'b0;
			end else if (d_bus[15] == 1'b1) begin
				n_next = 1'b1;
				p_next = 1'b0;
				z_next = 1'b0;
			end else begin
				p_next = 1'b1;
				z_next = 1'b0;
				n_next = 1'b0;
			end
		end
		
		if (LD_PC) begin
			if (PCMUX == 0)
				PC_next = PC + 16'h0001;
			else if (PCMUX == 1)
				PC_next = marmux;
			else if (PCMUX == 2) 
				PC_next = d_bus;
		end 
		
		if (LD_BEN) begin
			if ((IR[11] & n) | (IR[10] & z) | (IR[9] & p))
				BEN_next = 1'b1;
			else
				BEN_next = 1'b0;
		end
		
		if (LD_MDR) begin
			if (MIO_EN)
				MDR_next = MDR_In;
			else
				MDR_next = d_bus;
		end
		
		if (LD_LED) begin
			LED_next = ledVect;
		end
		
	end
	


endmodule 