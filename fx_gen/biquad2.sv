module biquad2(
  input CLOCK_50, reset_h, new_sample, 
  input logic [15:0] sample_in, 
  input int a0, a1, a2, b1, b2,
  input int a0_w, a1_w, a2_w, b1_w, b2_w,  
  output logic [15:0] sample_out, 
  output logic computation_done);

int x0, x1, x2, y0, y1, y2, x0_n, x1_n, x2_n, y0_n, y1_n, y2_n;
int x0out, x1out, x2out, y1out, y2out; // fp: 20.16

assign sample_out = y0[15:0];


enum logic [2:0] {RESET, NEW_SAMPLE, COMPUTE} state, next_state;


always_ff @ (posedge CLOCK_50)
begin
  if (reset_h) begin
    state <= RESET;
  end
  else begin
    state <= next_state;
    x0 <= x0_n;
    x1 <= x1_n;
    x2 <= x2_n;
    y0 <= y0_n;
    y1 <= y1_n;
    y2 <= y2_n;
  end
end


assign x0out = x0/a0 + (x0* a0_w); 
assign x1out = x1/a1 + (x1* a1_w);
assign x2out = x2/a2 + (x2* a2_w); 
assign y1out = y1/b1 + (y1* b1_w); 
assign y2out = y2/b2 + (y2* b2_w); 




always_comb
begin
  //next state logic
  next_state = state;
  case (state)
    RESET: begin
      if (new_sample)
        next_state = NEW_SAMPLE;
    end
    NEW_SAMPLE: begin
      next_state = COMPUTE;
    end
    COMPUTE: begin
      if (~new_sample)
        next_state = RESET;
    end
  endcase


  //control signals and processing
  computation_done = 1'b0;

  // values updated
  x0_n = x0;
  x1_n = x1;
  x2_n = x2;
  y0_n = y0;
  y1_n = y1;
  y2_n = y2;


case (state)
    NEW_SAMPLE: begin
      if (sample_in[15])
        x0_n = {16'hFFFF, sample_in};
      else 
        x0_n = {16'h0000, sample_in};
      x1_n = x0;
      x2_n = x1;
      y1_n = y0;
      y2_n = y1;
    end
    COMPUTE: begin
      y0_n = x0out + x1out + x2out + y1out + y2out ;
      computation_done = 1'b1;
    end
    default: begin
    end
  endcase
end

endmodule