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
   logic c1, c2, c3;
	logic c4, c5, c6, c7;
	logic c8, c9, c10, c11;
	logic c12, c13, c14, c15;
	
	logic[15:0] co;
	
	full_adder FA0(.x(A[0]), .y(B[0]), .z(0), .s(Sum[0]), .c(co[0]));
	
	prop_gen p1(.m(A[1]), .n(B[1]), .c_i(co[0]), .c_ii(c1));
	full_adder FA1(.x(A[1]), .y(B[1]), .z(c1), .s(Sum[1]), .c(co[1]));
	prop_gen p2(.m(A[2]), .n(B[2]), .c_i(co[1]), .c_ii(c2));
	full_adder FA2(.x(A[2]), .y(B[2]), .z(c2), .s(Sum[2]), .c(co[2]));
	prop_gen p3(.m(A[3]), .n(B[3]), .c_i(co[2]), .c_ii(c3));
	full_adder FA3(.x(A[3]), .y(B[3]), .z(c3), .s(Sum[3]), .c(co[3]));
	
	prop_gen p4(.m(A[4]), .n(B[4]), .c_i(co[3]), .c_ii(c4));
	full_adder FA4(.x(A[4]), .y(B[4]), .z(c4), .s(Sum[4]), .c(co[4]));
	prop_gen p5(.m(A[5]), .n(B[5]), .c_i(co[4]), .c_ii(c5));
	full_adder FA5(.x(A[5]), .y(B[5]), .z(c5), .s(Sum[5]), .c(co[5]));
	prop_gen p6(.m(A[6]), .n(B[6]), .c_i(co[5]), .c_ii(c6));
	full_adder FA6(.x(A[6]), .y(B[6]), .z(c6), .s(Sum[6]), .c(co[6]));
	prop_gen p7(.m(A[7]), .n(B[7]), .c_i(co[6]), .c_ii(c7));
	full_adder FA7(.x(A[7]), .y(B[7]), .z(c7), .s(Sum[7]), .c(co[7])); 
	
	prop_gen p8(.m(A[8]), .n(B[8]), .c_i(co[7]), .c_ii(c8));
	full_adder FA8(.x(A[8]), .y(B[8]), .z(c8), .s(Sum[8]), .c(co[8]));
	prop_gen p9(.m(A[9]), .n(B[9]), .c_i(co[8]), .c_ii(c9));
	full_adder FA9(.x(A[9]), .y(B[9]), .z(c9), .s(Sum[9]), .c(co[9]));
	prop_gen p10(.m(A[10]), .n(B[10]), .c_i(co[9]), .c_ii(c10));
	full_adder FA10(.x(A[10]), .y(B[10]), .z(c10), .s(Sum[10]), .c(co[10]));
	prop_gen p11(.m(A[11]), .n(B[11]), .c_i(co[10]), .c_ii(c11));
	full_adder FA11(.x(A[11]), .y(B[11]), .z(c11), .s(Sum[11]), .c(co[11]));

	prop_gen p12(.m(A[12]), .n(B[12]), .c_i(co[11]), .c_ii(c12));
	full_adder FA12(.x(A[12]), .y(B[12]), .z(c12), .s(Sum[12]), .c(co[12]));
	prop_gen p13(.m(A[13]), .n(B[13]), .c_i(co[12]), .c_ii(c13));
	full_adder FA13(.x(A[13]), .y(B[13]), .z(c13), .s(Sum[13]), .c(co[13]));
	prop_gen p14(.m(A[14]), .n(B[14]), .c_i(co[13]), .c_ii(c14));
	full_adder FA14(.x(A[14]), .y(B[14]), .z(c14), .s(Sum[14]), .c(co[14]));
	prop_gen p15(.m(A[15]), .n(B[15]), .c_i(co[14]), .c_ii(c15));
	full_adder FA15(.x(A[15]), .y(B[15]), .z(c15), .s(Sum[15]), .c(CO));
	
endmodule

module prop_gen (input m, n, c_i, output logic c_ii);

	logic p, g;
	
	assign g = m & n;
	assign p = m ^ n;
	assign c_ii = g | (p & c_i);
	
endmodule
