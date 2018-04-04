/**
 * Inverse AddRoundKey
 */
module InvAddRoundKey(
	input logic [127:0] state, 
	input logic[1407:0] KeySchedule, 
	input logic [3:0] round, 
	output logic [127:0] updatedState);
	
 // XOR the values in state and the keyschedule 

	logic [31:0] wp0, wp1, wp2, wp3;
	logic [7:0]  wp0a, wp0b, wp0c, wp0d, wp1a, wp1b, wp1c, wp1d;
	logic [7:0]  wp2a, wp2b, wp2c, wp2d, wp3a, wp3b, wp3c, wp3d;

	assign {wp0a, wp0b, wp0c, wp0d} = wp0;
	assign {wp1a, wp1b, wp1c, wp1d} = wp1;
	assign {wp2a, wp2b, wp2c, wp2d} = wp2;
	assign {wp3a, wp3b, wp3c, wp3d} = wp3;
	
	always_comb 
	begin
		// Always comb to update the variables based on the start and end points
		case (round)
			1: {wp0, wp1, wp2, wp3} = KeySchedule[1279:1152];
			2: {wp0, wp1, wp2, wp3} = KeySchedule[1151:1024];
			3: {wp0, wp1, wp2, wp3} = KeySchedule[1023:896];
			4: {wp0, wp1, wp2, wp3} = KeySchedule[895:768];
			5: {wp0, wp1, wp2, wp3} = KeySchedule[767:640];
			6: {wp0, wp1, wp2, wp3} = KeySchedule[639:512];
			7: {wp0, wp1, wp2, wp3} = KeySchedule[511:384];
			8: {wp0, wp1, wp2, wp3} = KeySchedule[383:256];
			9: {wp0, wp1, wp2, wp3} = KeySchedule[255:128];
			10: {wp0, wp1, wp2, wp3} = KeySchedule[127:0];
			default: {wp0, wp1, wp2, wp3} = KeySchedule[1407:1280];
		endcase
		
		// column 1
		updatedState[7:0] = state[7:0] ^ wp3d;
		updatedState[15:8] = state[15:8] ^ wp3c;
		updatedState[23:16] = state[23:16] ^ wp3b;
		updatedState[31:24] = state[31:24] ^ wp3a;

		// Column 2
		updatedState[39:32] = state[39:32] ^ wp2d;
		updatedState[47:40] = state[47:40] ^ wp2c;
		updatedState[55:48] = state[55:48] ^ wp2b;
		updatedState[63:56] = state[63:56] ^ wp2a;

		// Column 3 
		updatedState[71:64] = state[71:64] ^ wp1d;
		updatedState[79:72] = state[79:72] ^ wp1c;
		updatedState[87:80] = state[87:80] ^ wp1b;
		updatedState[95:88] = state[95:88] ^ wp1a;


		// Column 4
		updatedState[103:96] = state[103:96] ^ wp0d;
		updatedState[111:104] = state[111:104] ^ wp0c;
		updatedState[119:112] = state[119:112] ^ wp0b;
		updatedState[127:120] = state[127:120] ^ wp0a;
	end
	

	
endmodule 