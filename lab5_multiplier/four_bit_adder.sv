module four_bit_adder (input[3:0] a, input[3:0] b,
								input Cin,
								output[3:0] S, output Cout);

	logic c0, c1, c2;
	full_adder FA0(.x(a[0]), .y(b[0]), .z(Cin), .s(S[0]), .c(c0));
	full_adder FA1(.x(a[1]), .y(b[1]), .z(c0), .s(S[1]), .c(c1));
	full_adder FA2(.x(a[2]), .y(b[2]), .z(c1), .s(S[2]), .c(c2));
	full_adder FA3(.x(a[3]), .y(b[3]), .z(c2), .s(S[3]), .c(Cout));

endmodule


module full_adder (input x, y, z, output s, c);

	assign s = x ^ y ^ z;
	assign c = (x&y) | (y&z) | (x&z);
	
endmodule
