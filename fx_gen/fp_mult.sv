module fp_mult(
  input [15:0] sample, 
  input signed [7:0] coefficient, //using fp:4.4 for now
  output [15:0] fp_out
  );
  
  logic signed [23:0] multiply;
  
  assign multiply = sample * coefficient;
  
  assign fp_out = multiply[20:5];
  
  

endmodule 