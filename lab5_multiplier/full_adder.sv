module full_adder(input logic a, input logic b, input logic Cin,
						output logic S, output logic C);
	assign S = a ^ b ^ Cin;
	assign C = (a&b) | (a&Cin) | (b*Cin);
endmodule 