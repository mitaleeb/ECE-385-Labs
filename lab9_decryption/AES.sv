/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE, hardware_write, running, 
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

// Next logic
	logic [127:0] AES_MSG_DEC_next;
	logic AES_DONE_next, hardware_write_next, running_next;

// Key expansion 
	logic [1407:0] KeySchedule;
	KeyExpansion keyex(.Cipherkey(AES_KEY), .clk(CLK), .KeySchedule(KeySchedule));
	
// Add Rounds
	logic [3:0] round, nextRound; 
	logic [127:0] state, nextState;
	logic [127:0] updatedState_shift_rows, updatedState_subbytes, updatedState_roundkey, updatedState_mix_cols;
	InvAddRoundKey rounds(.state(state), .KeySchedule(KeySchedule), .round(round), .updatedState(updatedState_roundkey));

	
// Inverse Shift Rows Initialization 
	InvShiftRows shift_row(.data_in(state), .data_out(updatedState_shift_rows));

//Inverse Sub Bytes Initialization 
	InvSubBytes invsb0(.clk(CLK), .in(state[7:0]), .out(updatedState_subbytes[7:0]));
	InvSubBytes invsb1(.clk(CLK), .in(state[15:8]), .out(updatedState_subbytes[15:8]));
	InvSubBytes invsb2(.clk(CLK), .in(state[23:16]), .out(updatedState_subbytes[23:16]));
	InvSubBytes invsb3(.clk(CLK), .in(state[31:24]), .out(updatedState_subbytes[31:24]));
	InvSubBytes invsb4(.clk(CLK), .in(state[39:32]), .out(updatedState_subbytes[39:32]));
	InvSubBytes invsb5(.clk(CLK), .in(state[47:40]), .out(updatedState_subbytes[47:40]));
	InvSubBytes invsb6(.clk(CLK), .in(state[55:48]), .out(updatedState_subbytes[55:48]));
	InvSubBytes invsb7(.clk(CLK), .in(state[63:56]), .out(updatedState_subbytes[63:56]));
	InvSubBytes invsb8(.clk(CLK), .in(state[71:64]), .out(updatedState_subbytes[71:64]));
	InvSubBytes invsb9(.clk(CLK), .in(state[79:72]), .out(updatedState_subbytes[79:72]));
	InvSubBytes invsb10(.clk(CLK), .in(state[87:80]), .out(updatedState_subbytes[87:80]));
	InvSubBytes invsb11(.clk(CLK), .in(state[95:88]), .out(updatedState_subbytes[95:88]));
	InvSubBytes invsb12(.clk(CLK), .in(state[103:96]), .out(updatedState_subbytes[103:96]));
	InvSubBytes invsb13(.clk(CLK), .in(state[111:104]), .out(updatedState_subbytes[111:104]));
	InvSubBytes invsb14(.clk(CLK), .in(state[119:112]), .out(updatedState_subbytes[119:112]));
	InvSubBytes invsb15(.clk(CLK), .in(state[127:120]), .out(updatedState_subbytes[127:120]));

// Inverse Mix Columns Initialization 
	InvMixColumns invmx0(.in(state[31:0]), .out(updatedState_mix_cols[31:0]));
	InvMixColumns invmx1(.in(state[63:32]), .out(updatedState_mix_cols[63:32]));
	InvMixColumns invmx2(.in(state[95:64]), .out(updatedState_mix_cols[95:64]));
	InvMixColumns invmx3(.in(state[127:96]), .out(updatedState_mix_cols[127:96]));
	
	
// Define state machine next state logic 
	enum logic [5:0] {Round_Ten, InverseShiftRows, InverseSubBytes, AddRoundKey, 
			InverseMixColumns, InverseShiftRows_b, InverseSubBytes_b, AddRoundKey_b, HALT, 
			dumb1, dumb2, dumb3, dumb4, dumb5, dumb6, toRoundNine}
			State, Next_state;   // Internal state logic
	
// Next state logic 	
	always_ff @ (posedge CLK)
	begin
		if(!RESET) begin 
			State <= Next_state;
			AES_DONE <= AES_DONE_next;
		end 
		else begin 
			State <= HALT;
			AES_DONE <= 0;
		end
		
		round <= nextRound;
		AES_MSG_DEC <= AES_MSG_DEC_next;	
		state <= nextState;
		hardware_write <= hardware_write_next;
		running <= running_next;
	end
	
	always_comb
	begin
		Next_state = State;
		nextState = state;
		nextRound = round;
		AES_MSG_DEC_next = AES_MSG_DEC;
		AES_DONE_next = AES_DONE;
		hardware_write_next = hardware_write;
		running_next = running;
		
		unique case(State)
		dumb1: 
			Next_state = dumb2;
		dumb2:
			Next_state = dumb3;
		dumb3: 
			Next_state = dumb4;
		dumb4: 
			Next_state = dumb5;
		dumb5: 
			Next_state = dumb6;
		dumb6: 
			Next_state = Round_Ten;
		Round_Ten:
			Next_state = toRoundNine;
		toRoundNine: 
			Next_state = InverseShiftRows;
		InverseShiftRows:
			Next_state = InverseSubBytes;
		InverseSubBytes:
			Next_state = AddRoundKey;
		AddRoundKey:
			Next_state = InverseMixColumns; 
		InverseMixColumns:
			if(round > 1) begin 
				nextRound = round - 1;
				Next_state = InverseShiftRows;
			end 
			else begin
				Next_state = InverseShiftRows_b;
			end
		InverseShiftRows_b:
			Next_state = InverseSubBytes_b;
		InverseSubBytes_b:
			Next_state = AddRoundKey_b;	
		AddRoundKey_b:
			Next_state = HALT;
		HALT: begin
			if(AES_START) begin
				AES_DONE_next = 0;
				Next_state = dumb1;
				hardware_write_next = 0;
				running_next = 1;
			end 
			else begin
				Next_state = HALT;
				hardware_write_next = 0;
				running_next = 0;
			end 
		end 
		endcase
		
		case(State)
		dumb6: begin
			nextState = AES_MSG_ENC;
			nextRound = 10;
		end
		Round_Ten: begin 
			nextState = updatedState_roundkey;
			end 
		toRoundNine: begin
			nextRound = 9;
		end
		InverseShiftRows: begin 
			nextState = updatedState_shift_rows;
			end 
		InverseSubBytes:
			nextState = updatedState_subbytes;
		AddRoundKey: begin 
			//round = 9;
			nextState = updatedState_roundkey;
		end 
		InverseMixColumns: begin 
			nextState = updatedState_mix_cols;
		end 
		InverseShiftRows_b: begin 
			nextState = updatedState_shift_rows;
		end 
		InverseSubBytes_b: begin 
			nextState = updatedState_subbytes;
			nextRound = 0;
		end 
		AddRoundKey_b: begin 
			nextState = updatedState_roundkey; 
			AES_MSG_DEC_next = nextState;
			AES_DONE_next = 1;
			hardware_write_next = 1;
			running_next = 0;
		end 
		default: ;
		endcase
	end


endmodule
