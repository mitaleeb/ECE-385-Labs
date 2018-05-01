/**
 * @file bar.sv
 * @author Dean Biskup and Mitalee Bharadwaj
 *
 * For ECE 385 Final Project, Spring 2018
 *
 * This module describes the motions of the bars.
 */
module bars(
  input clk, // 50 MHz clock
  input reset_h, 
  input frame_clk, // The clock indicating a new frame, aka Vsync
  input [9:0] DrawX, DrawY, // The current coordinates

  // The register file holding the previous inputs we will represent
  input logic [15:0] register_fileL[32],
  input logic [15:0] register_fileR[32],  

  // Outputs
  output logic isBar // Whether the current pixel is part of a bar
  );

// Note that the isBar logic will be part of the object signal 
// in colormapper. We'll set it it object[0]

parameter [9:0] BAR_WIDTH = 10'd10; // Width of a bar
parameter [9:0] BAR_START_X = 10'd0; // X coordinate of beginning of the graph
parameter [9:0] BAR_START_Y = 10'd240; // Y coordinate of beginning of bars

// Local registers
logic [9:0] bar_heights[64], bar_heights_next[64];

// Detect the rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge clk) begin
  frame_clk_delayed <= frame_clk;
  frame_clk_rising_edge <= (frame_clk) && (~frame_clk_delayed);
end // always_ff @ (posedge clk)

// Update registers
always_ff @ (posedge clk) begin
  if (reset_h) begin
    for (int i = 0; i < 64; i++) begin
      bar_heights[i] <= 10'b0;
    end // for (int i = 0; i < 64; i++)
  end else begin
    for (int i = 0; i < 64; i++) begin
      bar_heights[i] <= bar_heights_next[i];
    end 
  end
end // always_ff @ (posedge clk)

// Always comb decides the 
always_comb begin
  for (int i = 0; i < 64; i++) begin
    bar_heights_next[i] = bar_heights[i];
  end
  // Only update when the frame clock is rising edge
  if (frame_clk_rising_edge) begin
    // Do the math for the height of the bars
    // @todo: make this accurate
    for (int i = 0; i < 32; i++)
      bar_heights_next[i] = register_fileL[i] % 200;
    for (int i = 32; i < 64; i++)
      bar_heights_next[i] = register_fileR[i-32] % 200;
  end 
end 

// Computer whether a pixel corresponds to a bar
int index;
assign index = DrawX / BAR_WIDTH;

always_comb begin
  if (DrawY < BAR_START_Y + bar_heights[index]) begin
    if (DrawY > BAR_START_Y - bar_heights[index]) begin
      isBar = 1'b1;
    end else isBar = 1'b0;
  end else isBar = 1'b0;
end


endmodule // bars
