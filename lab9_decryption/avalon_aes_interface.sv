/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET, // Active Low
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	// Define a 16x32 reg file
	logic [31:0] AES_KEY0; // 0
	logic [31:0] AES_KEY1; // 1
	logic [31:0] AES_KEY2; // 2
	logic [31:0] AES_KEY3; // 3
	logic [31:0] AES_MSG_EN0; // 4
	logic [31:0] AES_MSG_EN1; // 5
	logic [31:0] AES_MSG_EN2; // 6
	logic [31:0] AES_MSG_EN3; // 7
	logic [31:0] AES_MSG_DE0; // 8
	logic [31:0] AES_MSG_DE1; // 9
	logic [31:0] AES_MSG_DE2; // 10
	logic [31:0] AES_MSG_DE3; // 11
	logic [31:0] AES_START; // 14
	logic [31:0] AES_DONE; //15
	
	// Next intermediate registers
	logic [31:0] AES_KEY0_next;
	logic [31:0] AES_KEY1_next;
	logic [31:0] AES_KEY2_next;
	logic [31:0] AES_KEY3_next;
	logic [31:0] AES_MSG_EN0_next;
	logic [31:0] AES_MSG_EN1_next;
	logic [31:0] AES_MSG_EN2_next;
	logic [31:0] AES_MSG_EN3_next;
	logic [31:0] AES_MSG_DE0_next;
	logic [31:0] AES_MSG_DE1_next;
	logic [31:0] AES_MSG_DE2_next;
	logic [31:0] AES_MSG_DE3_next;
	logic [31:0] AES_START_next;
	logic [31:0] AES_DONE_next;
	
	logic [31:0] AVL_READDATA_next; 
	
	// Assign some stuff for big 128bit stuff
	logic [127:0] AES_KEY;
	assign AES_KEY[127:96] = AES_KEY3;
	assign AES_KEY[95:64] = AES_KEY2;
	assign AES_KEY[63:32] = AES_KEY1;
	assign AES_KEY[31:0] = AES_KEY0;
	
	// Assign export_data
	assign EXPORT_DATA[15:0] = AES_KEY[15:0];
	assign EXPORT_DATA[31:16] = AES_KEY[127:112];

	always_ff @ (posedge CLK) begin
		//stuff
		if (RESET) begin
			AES_KEY0 <= 0;
			AES_KEY1 <= 0;
			AES_KEY2 <= 0;
			AES_KEY3 <= 0;
			AES_MSG_EN0 <= 0;
			AES_MSG_EN1 <= 0;
			AES_MSG_EN2 <= 0;
			AES_MSG_EN3 <= 0;
			AES_MSG_DE0 <= 0;
			AES_MSG_DE1 <= 0;
			AES_MSG_DE2 <= 0;
			AES_MSG_DE3 <= 0;
			AES_DONE <= 0;
			AES_START <= 0;
			AVL_READDATA <= 0;
		end else begin
			AES_KEY0 <= AES_KEY0_next;
			AES_KEY1 <= AES_KEY1_next;
			AES_KEY2 <= AES_KEY2_next;
			AES_KEY3 <= AES_KEY3_next;
			AES_MSG_EN0 <= AES_MSG_EN0_next;
			AES_MSG_EN1 <= AES_MSG_EN1_next;
			AES_MSG_EN2 <= AES_MSG_EN2_next;
			AES_MSG_EN3 <= AES_MSG_EN3_next;
			AES_MSG_DE0 <= AES_MSG_DE0_next;
			AES_MSG_DE1 <= AES_MSG_DE1_next;
			AES_MSG_DE2 <= AES_MSG_DE2_next;
			AES_MSG_DE3 <= AES_MSG_DE3_next;
			AES_DONE <= AES_DONE_next;
			AES_START <= AES_START_next;
			AVL_READDATA <= AVL_READDATA_next;
		end
	end
	
	always_comb begin
		// stuff 2
		AES_KEY0_next = AES_KEY0;
		AES_KEY1_next = AES_KEY1;
		AES_KEY2_next = AES_KEY2;
		AES_KEY3_next = AES_KEY3;
		AES_MSG_EN0_next = AES_MSG_EN0;
		AES_MSG_EN1_next = AES_MSG_EN1;
		AES_MSG_EN2_next = AES_MSG_EN2;
		AES_MSG_EN3_next = AES_MSG_EN3;
		AES_MSG_DE0_next = AES_MSG_DE0;
		AES_MSG_DE1_next = AES_MSG_DE1;
		AES_MSG_DE2_next = AES_MSG_DE2;
		AES_MSG_DE3_next = AES_MSG_DE3;
		AES_DONE_next = AES_DONE;
		AES_START_next = AES_START;
		AVL_READDATA_next = AVL_READDATA;
		
		// Put logic here
		if (AVL_WRITE) begin
			if (AVL_ADDR == 4'd0)
				AES_KEY0_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd1)
				AES_KEY1_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd2)
				AES_KEY2_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd3)
				AES_KEY3_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd4)
				AES_MSG_EN0_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd5)
				AES_MSG_EN1_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd6)
				AES_MSG_EN2_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd7)
				AES_MSG_EN3_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd8)
				AES_MSG_DE0_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd9)
				AES_MSG_DE1_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd10)
				AES_MSG_DE2_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd11)
				AES_MSG_DE3_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd14)
				AES_START_next = AVL_WRITEDATA;
			if (AVL_ADDR == 4'd15)
				AES_DONE_next = AVL_WRITEDATA;
		end
		
		// Read logic
		if (AVL_READ) begin
			if (AVL_ADDR == 4'd0)
				AVL_READDATA_next = AES_KEY0;
			if (AVL_ADDR == 4'd1)
				AVL_READDATA_next = AES_KEY1;
			if (AVL_ADDR == 4'd2)
				AVL_READDATA_next = AES_KEY2;
			if (AVL_ADDR == 4'd3)
				AVL_READDATA_next = AES_KEY3;
			if (AVL_ADDR == 4'd4)
				AVL_READDATA_next = AES_MSG_EN0;
			if (AVL_ADDR == 4'd5)
				AVL_READDATA_next = AES_MSG_EN1;
			if (AVL_ADDR == 4'd6)
				AVL_READDATA_next = AES_MSG_EN2;
			if (AVL_ADDR == 4'd7)
				AVL_READDATA_next = AES_MSG_EN3;
			if (AVL_ADDR == 4'd8)
				AVL_READDATA_next = AES_MSG_DE0;
			if (AVL_ADDR == 4'd9)
				AVL_READDATA_next = AES_MSG_DE1;
			if (AVL_ADDR == 4'd10)
				AVL_READDATA_next = AES_MSG_DE2;
			if (AVL_ADDR == 4'd11)
				AVL_READDATA_next = AES_MSG_DE3;
			if (AVL_ADDR == 4'd14)
				AVL_READDATA_next = AES_START;
			if (AVL_ADDR == 4'd15)
				AVL_READDATA_next = AES_DONE;
		end		
	end

endmodule
