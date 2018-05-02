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
  input logic [15:0] register_fileL[128],
  input logic [15:0] register_fileR[128],  

  // Outputs
  output logic isBar // Whether the current pixel is part of a bar
  );

// Note that the isBar logic will be part of the object signal 
// in colormapper. We'll set it it object[0]

parameter [9:0] BAR_WIDTH = 10'd5; // Width of a bar
parameter [9:0] BAR_START_X = 10'd0; // X coordinate of beginning of the graph
parameter [9:0] BAR_START_Y_L = 10'd120; // beginning y of left
parameter [9:0] BAR_START_Y_R = 10'd360;
parameter [9:0] BAR_VAL_PER_PIXEL = 10'd170;
parameter [9:0] MAX_BAR_HEIGHT = 10'd120;

// Local registers
logic [6:0] bar_heightsR[128], bar_heightsR_next[128];
logic [6:0] bar_heightsL[128], bar_heightsL_next[128];

// Detect the rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge clk) begin
  frame_clk_delayed <= frame_clk;
  frame_clk_rising_edge <= (frame_clk) && (~frame_clk_delayed);
end // always_ff @ (posedge clk)

// Update registers
always_ff @ (posedge clk) begin
  if (reset_h) begin
    for (int i = 0; i < 128; i++) begin
      bar_heightsL[i] <= 7'b0;
		bar_heightsR[i] <= 7'b0;
    end // for (int i = 0; i < 64; i++)
  end else begin
    for (int i = 0; i < 128; i++) begin
      bar_heightsL[i] <= bar_heightsL_next[i];
		bar_heightsR[i] <= bar_heightsR_next[i];
    end 
  end
end // always_ff @ (posedge clk)

// Always comb decides the 
always_comb begin
  for (int i = 0; i < 128; i++) begin
    bar_heightsR_next[i] = bar_heightsR[i];
	 bar_heightsL_next[i] = bar_heightsL[i];
  end
  // Only update when the frame clock is rising edge
  if (frame_clk_rising_edge) begin
    // Do the math for the height of the bars
    // @todo: make this accurate
    for (int i = 0; i < 128; i++) begin
      bar_heightsL_next[i] = (~register_fileL[i] + 1) / BAR_VAL_PER_PIXEL;
		bar_heightsR_next[i] = (~register_fileR[i] + 1) / BAR_VAL_PER_PIXEL;
	 end
  end 
end 

// Computer whether a pixel corresponds to a bar
int index;
assign index = DrawX / BAR_WIDTH;

always_comb begin
  isBar = 1'b0;
  
  if (DrawY < BAR_START_Y_L + bar_heightsL[index]) begin
    if (DrawY > BAR_START_Y_L - bar_heightsL[index])
		isBar = 1'b1;
  end
  
  if (DrawY < BAR_START_Y_R + bar_heightsR[index]) begin
    if (DrawY > BAR_START_Y_R - bar_heightsR[index])
		isBar = 1'b1;
  end 
end


endmodule // bars
