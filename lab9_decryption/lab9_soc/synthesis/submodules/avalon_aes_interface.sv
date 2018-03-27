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
	logic [31:0] AES_KEY0;
	logic [31:0] AES_KEY1;
	logic [31:0] AES_KEY2;
	logic [31:0] AES_KEY3;
	logic [31:0] AES_MSG_EN0;
	logic [31:0] AES_MSG_EN1;
	logic [31:0] AES_MSG_EN2;
	logic [31:0] AES_MSG_EN3;
	logic [31:0] AES_MSG_DE0;
	logic [31:0] AES_MSG_DE1;
	logic [31:0] AES_MSG_DE2;
	logic [31:0] AES_MSG_DE3;
	logic [31:0] AES_START;
	logic [31:0] AES_DONE;
	
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
	
	// Assign some stuff for big 128bit stuff
	logic [127:0] AES_KEY;
	assign AES_KEY[127:96] = AES_KEY3;
	assign AES_KEY[95:64] = AES_KEY2;
	assign AES_KEY[63:32] = AES_KEY1;
	assign AES_KEY[31:0] = AES_KEY0;
	
	// Assign export_data
	assign EXPORT_DATA[15:0] = AES_KEY[15:0];
	assign EXPORT_DATA[31:16] = AES_KEY[127:112];

	always_ff(@posedge CLK) begin
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
		
		// Put logic here
		
	end

endmodule
