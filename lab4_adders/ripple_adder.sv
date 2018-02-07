module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	
	logic c0, c1, c2;
	
	four_bit_adder FBA0(.a(A[3:0]), .b(B[3:0]), .Cin(0), .S(Sum[3:0]), .Cout(c0));
	four_bit_adder FBA1(.a(A[7:4]), .b(B[7:4]), .Cin(c0), .S(Sum[7:4]), .Cout(c1));
	four_bit_adder FBA2(.a(A[11:8]), .b(B[11:8]), .Cin(c1), .S(Sum[11:8]), .Cout(c2));
	four_bit_adder FBA3(.a(A[15:12]), .b(B[15:12]), .Cin(c2), .S(Sum[15:12]), .Cout(CO));
	
endmodule

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