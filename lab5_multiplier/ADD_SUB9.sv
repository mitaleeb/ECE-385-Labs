module ADD_SUB9 
(input [7:0] A, input [7:0] B, input f_n, output [8:0] S);

	logic c0, c1; 
	logic [7:0] BB;
	logic A8, BB8;

	assign BB = (B ^ {8{f_n}});
	assign A8 = A[7];
	assign BB8= BB[7];

	four_bit_adder FBA0(.a(A[3:0]), .b(BB[3:0]), .Cin(f_n), .S(S[3:0]), .Cout(c0));
	four_bit_adder FBA1(.a(A[7:4]), .b(BB[7:4]), .Cin(c0), .S(S[7:4]), .Cout(c1));
	full_adder FA4(.x(A8), .y(BB8), .z(c1), .s(S[8]), .c());

endmodule 