module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  logic cout0, cout1, cout2;
	  
	  four_bit_adder FBA(.a(A[3:0]), .b(B[3:0]), .Cin(0), .S(Sum[3:0]), .Cout(cout0));
	  four_cs_adder FCA0(.x(A[7:4]), .y(B[7:4]), .Cin(cout0), .S(Sum[7:4]), .Carout(cout1));
	  four_cs_adder FCA1(.x(A[11:8]), .y(B[11:8]), .Cin(cout1), .S(Sum[11:8]), .Carout(cout2));
	  four_cs_adder FCA2(.x(A[15:12]), .y(B[15:12]), .Cin(cout2), .S(Sum[15:12]), .Carout(CO));
     
endmodule

module two_one_mux(input logic in0, input logic in1, input logic sel, output logic mux_out);
	assign mux_out = (sel) ? in1 : in0;
endmodule

module four_cs_adder(input logic[3:0] x, input logic[3:0] y, input Cin, output logic[3:0] S, output logic Carout);
	
	logic[3:0] s0, s1;
	logic c0, c1;
	
	four_bit_adder FBA0(.a(x[3:0]), .b(y[3:0]), .Cin(0), .S(s0[3:0]), .Cout(c0));
	four_bit_adder FBA1(.a(x[3:0]), .b(y[3:0]), .Cin(1), .S(s1[3:0]), .Cout(c1));
	
	two_one_mux SUM0(.in0(s0[0]), .in1(s1[0]), .sel(Cin), .mux_out(S[0]));
	two_one_mux SUM1(.in0(s0[1]), .in1(s1[1]), .sel(Cin), .mux_out(S[1]));
	two_one_mux SUM2(.in0(s0[2]), .in1(s1[2]), .sel(Cin), .mux_out(S[2]));
	two_one_mux SUM3(.in0(s0[3]), .in1(s1[3]), .sel(Cin), .mux_out(S[3]));
	two_one_mux C(.in0(c0), .in1(c1), .sel(Cin), .mux_out(Carout));
endmodule

