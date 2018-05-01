/**
 * This module holds the past 50 samples from the input stream
 *
 * Dean Biskup and Mitalee Bharadwaj, 2018
 *
 * ECE 385 Final Project
 */
module pastsignals(
  input clk, reset_h, 
  input [6:0] index, 
  input AUD_DACLRCK, 
  input [15:0] sample_in, 
  input read, 
  output [15:0] READ_DATA
  );

// index 0 will be the most recent one
logic [15:0] register_file[64];
logic [15:0] register_file_next[64];

logic shift, new_sample;

always_ff @ (posedge clk) begin
  if (reset_h) begin
    for (int i = 0; i < 64; i++) begin
      register_file[i] <= 0;
    end // for (int i = 0; i < 50; i++)
    shift <= 0;
    new_sample <= 0;
  end else if (shift) begin
    for (int i = 0; i < 64; i++) begin
      register_file[i] <= register_file_next[i];
    end // for (int i = 0; i < 64; i++)
  end else if (new_sample) begin
    for (int i = 0; i < 63; i++) begin
      register_file_next[i+1] <= register_file[i];
    end 
    register_file_next[0] <= sample_in;
  end 
end // always_ff @ (posedge clk)

assign READ_DATA = (read) ? register_file[index] : 16'b0;

// State machine to control the operation of this when a new signal comes into play

enum logic[3:0] {IDLE, NEWSAMPLE, SHIFT, DONE} state, next_state;

always_ff @ (posedge clk) begin
  state <= next_state;
end // always_ff @ (posedge clk)

always_comb begin
  next_state = state;
  new_sample = 0;
  shift = 0;
  // next_state logic
  case (state)
    IDLE: begin
      if (AUD_DACLRCK)
        next_state = NEWSAMPLE;
    end // IDLE:
    NEWSAMPLE: begin
      new_sample = 1;
      next_state = SHIFT;
    end // NEWSAMPLE:
    SHIFT: begin
      shift = 1;
      next_state = DONE;
    end // SHIFT:
    DONE: begin
      if (~AUD_DACLRCK)
        next_state = IDLE;
    end // DONE:
  endcase // state
end // always_comb

endmodule // pastsignals