/**
 * @file color_mapper.sv
 *
 * By Dean Biskup and Mitalee Bharadwaj
 *
 * For use in the Final Project, ECE 385 Spring 2018
 *
 * Heavily based on the Color_Mapper module provided for lab 8, but
 * with significant modifications.
 */
module color_mapper(
  input [2:0] object, // bg = 0, bar = 1, hat = 2
  input [9:0] DrawX, DrawY, // Current pixel coordinates
  output logic [7:0] VGA_R, VGA_G, VGA_B
  );

logic [7:0] red, green, blue;

// assign the output colors to the vga colors
assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;

// Always comb block to set the colors
always_comb begin
  if (object == 3'd1) begin
    // Make the bar white
    red = 8'hff;
    green = 8'hff;
    blue = 8'hff;
  end else if (object == 3'd2) begin
    // Also set the hat to be white
    red = 8'hff;
    green = 8'hff;
    blue = 8'hff;
  end else begin
    // Backgroundw ith a color gradient
    red = 8'h3f;
    green = 8'h00;
    blue = 8'h7f - {1'b0, DrawX[9:3]};
  end // end else
end // always_comb

endmodule // color_mapper