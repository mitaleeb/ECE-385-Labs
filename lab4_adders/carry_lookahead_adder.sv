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

	logic C0, C4, C8, C12;
	logic pg0, pg4, pg8, pg12;
	logic gg0, gg4, gg8, gg12;
	
	PG test0(.A(A[3:0]), .B(B[3:0]), .pg(pg0), .gg(gg0));
	PG test1(.A(A[7:4]), .B(B[7:4]), .pg(pg4), .gg(gg4));
	PG test2(.A(A[11:8]), .B(B[11:8]), .pg(pg8), .gg(gg8));
	PG test3(.A(A[15:12]), .B(B[15:12]), .pg(pg12), .gg(gg12));
	
	assign C0 = 0;
	assign C4 = (C0 & pg0) | gg0;
	assign C8 = (C4 & pg4) | gg4;
	assign C12 = (C8 & pg8) | gg8;
	assign CO = (C12 & pg12) | gg12;

	four_bit_cla FCLA1(.a(A[3:0]), .b(B[3:0]), .cinn(C0), .coutt(), .sout(Sum[3:0]));
	four_bit_cla FCLA2(.a(A[7:4]), .b(B[7:4]), .cinn(C4), .coutt(), .sout(Sum[7:4]));
	four_bit_cla FCLA3(.a(A[11:8]), .b(B[11:8]), .cinn(C8), .coutt(), .sout(Sum[11:8]));
	four_bit_cla FCLA4(.a(A[15:12]), .b(B[15:12]), .cinn(C12), .coutt(), .sout(Sum[15:12]));
	
endmodule

module four_bit_cla (input logic[3:0] a, input logic[3:0] b, input logic cinn, output logic coutt, 
							output logic[3:0] sout);
	
	logic c0, c1, c2, c3;
	assign c0 = cinn;
	assign c1 = (cinn & (a[0] ^ b[0])) | (a[0] & b[0]);
	assign c2 = (c1 & (a[1] ^ b[1])) | (a[1] & b[1]);
	assign c3 = (c2 & (a[2] ^ b[2])) | (a[2] & b[2]);
	assign coutt = (c3 & (a[3]^b[3])) | (a[3] & b[3]);
	
	logic[3:0] outs;
	full_adder f0(.x(a[0]), .y(b[0]), .z(c0), .s(sout[0]), .c(outs[0]));
	full_adder f1(.x(a[1]), .y(b[1]), .z(c1), .s(sout[1]), .c(outs[1]));
	full_adder f2(.x(a[2]), .y(b[2]), .z(c2), .s(sout[2]), .c(outs[2]));
	full_adder f3(.x(a[3]), .y(b[3]), .z(c3), .s(sout[3]), .c(outs[3]));

endmodule

module PG (input logic [3:0] A, input logic [3:0] B, output logic pg, output logic gg);
	assign pg = (A[0]^B[0]) & (A[1]^B[1]) & (A[2]^B[2]) & (A[3]^B[3]);
	assign gg = (A[3] & B[3]) | (A[2] & B[2]) & (A[3]^B[3]) | (A[1] & B[1]) & (A[3] ^ B[3]) & (A[2] ^ B[2]) | 
			(A[0] & B[0]) & (A[3]^B[3]) & (A[2]^B[2]) & (A[1] ^ B[1]);	
endmodule
