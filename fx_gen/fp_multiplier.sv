module fp_multiplier (
	input logic [15:0] sample_in,
	input signed [17:0] fp_coefficient, // fp: 3.15
	output logic [35:0] mult_out // fp: 19.17
);

logic signed [17:0] fp_a;

always_comb
begin
	fp_a = {sample_in, 2'b0}; // fp: 16.2
	mult_out = fp_a * fp_coefficient;

end

endmodule