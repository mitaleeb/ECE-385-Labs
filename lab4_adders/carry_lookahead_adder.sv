module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

	  logic C0, C1, C2;
	  
	  four_bit_cla FCLA1(.a(A[3:0]), .b(B[3:0]), .cinn(0), .coutt(C0), .sout(Sum[3:0]));
	  four_bit_cla FCLA2(.a(A[7:4]), .b(B[7:4]), .cinn(C0), .coutt(C1), .sout(Sum[7:4]));
	  four_bit_cla FCLA3(.a(A[11:8]), .b(B[11:8]), .cinn(C1), .coutt(C2), .sout(Sum[11:8]));
	  four_bit_cla FCLA4(.a(A[15:12]), .b(B[15:12]), .cinn(C2), .coutt(CO), .sout(Sum[15:12]));
	
endmodule

module four_bit_cla (input logic[3:0] a, input logic[3:0] b, input logic cinn, output logic coutt, output logic[3:0] sout);
	logic c0, c1, c2, c3;
	logic co_0, co_1, co_2;
	
	prop_gen p0(.m(a[0]), .n(b[0]), .c_i(cinn), .c_ii(c0));
	full_adder FA0(.x(a[0]), .y(b[0]), .z(c0), .s(sout[0]), .c(co_0));
	prop_gen p1(.m(a[1]), .n(b[1]), .c_i(co_0), .c_ii(c1));
	full_adder FA1(.x(a[1]), .y(b[1]), .z(c1), .s(sout[1]), .c(co_1));
	prop_gen p2(.m(a[2]), .n(b[2]), .c_i(co_1), .c_ii(c2));
	full_adder FA2(.x(a[2]), .y(b[2]), .z(c2), .s(sout[2]), .c(co_2));
	prop_gen p3(.m(a[3]), .n(b[3]), .c_i(co_2), .c_ii(c3));
	full_adder FA3(.x(a[3]), .y(b[3]), .z(c3), .s(sout[3]), .c(coutt));


endmodule

module prop_gen (input logic m, n, c_i, output logic c_ii);

	logic p, g;
	
	assign g = m & n;
	assign p = ~(m ^ n);
	assign c_ii = g | (p & c_i);
	
endmodule
