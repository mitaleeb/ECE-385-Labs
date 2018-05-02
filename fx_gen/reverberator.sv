module reverberator(
  input clk, reset_h, new_sample, 
  input [15:0] sample_in, 
  output [15:0] delayed_sample, 

  // SRAM stuff
  output [19:0] SRAM_ADDR, 
  inout wire [15:0] SRAM_DQ, 
  output SRAM_CE_N, SRAM_OE_N, SRAM_WE_N, 
  output SRAM_UB_N, SRAM_LB_N
  );

logic [15:0] data_to_sram; 
logic [15:0] data_from_sram;

tristate #(.N(16)) tr0(
    .Clk(clk), .tristate_output_enable(~SRAM_WE_N), .Data_write(data_to_sram), .Data_read(data_from_sram), .Data(SRAM_DQ)
);

assign data_to_sram = sample_in;

logic [19:0] address_input, address_output;
logic [19:0] address_input_n;

logic [15:0] delayed_sample_n;

assign address_output = (address_input == 6000) ? 20'b0 : address_input + 1;

// Need a state machine 
enum logic [4:0] {IDLE, WRITE, WRITE_DUMMY, READ, READ_DUMMY, WAIT} state, next_state;


always_ff @ (posedge clk) begin
  if (reset_h) begin
    state <= IDLE;
  end else begin
    state <= next_state;
    address_input <= address_input_n;
    delayed_sample <= delayed_sample_n;
  end 
end 

always_comb begin
  next_state = state;
  // Next state logic
  case (state) 
    IDLE: begin
      if (new_sample) begin
        next_state = WRITE;
      end 
    end 
    WRITE: begin
      next_state = WRITE_DUMMY;
    end 
    WRITE_DUMMY: begin
      next_state = READ;
    end 
    READ: begin
      next_state = READ_DUMMY;
    end 
    READ_DUMMY: begin
      next_state = WAIT;
    end 
    WAIT: begin
      if (~new_sample)
        next_state = IDLE;
    end // WAIT:
    default: ;
  endcase // state

  // Control signals and stuff
  address_input_n = address_input;
  delayed_sample_n = delayed_sample;

  SRAM_WE_N = 1'b1;
  SRAM_OE_N = 1'b1;
  SRAM_ADDR = 0;

  case (state)
    IDLE: begin
      if (new_sample) begin
        // lag by 6000 samples
        if (address_input == 6000)
          address_input_n = 0;
        else address_input_n = address_input + 1;
      end // if (new_sample)
    end // IDLE:
    WRITE: begin
      SRAM_WE_N = 1'b0;
      SRAM_ADDR = address_input;
      delayed_sample_n = data_from_sram;
    end 
    WRITE_DUMMY: begin
      SRAM_WE_N = 1'b0;
      SRAM_ADDR = address_input;
    end // WRITE_DUMMY:
    READ: begin
      SRAM_OE_N = 1'b0;
      SRAM_ADDR = address_output;
      delayed_sample_n = data_from_sram;
    end 
    READ_DUMMY: begin
      SRAM_OE_N = 1'b0;
      SRAM_ADDR = address_output;
      delayed_sample_n = data_from_sram;
    end // READ_DUMMY:
    default: ;
  endcase // state
end // always_comb




// These should always be active
assign SRAM_CE_N = 1'b0;
assign SRAM_UB_N = 1'b0;
assign SRAM_LB_N = 1'b0;

endmodule