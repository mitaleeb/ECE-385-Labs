module register_unit (input  logic Clk, ResetA, ResetB, X_in, Ld_A, Ld_B, 
                            Shift_En,
                      input  logic [7:0]  D_a, D_b, 
                      output logic B_out, 
							 output logic X, 
                      output logic [7:0]  A,
                      output logic [7:0]  B);

	// This code may not work, testing
	always_ff @ (posedge Clk) begin
		if (Ld_A)
			X <= X_in;
		else if (ResetA)
			X <= 1'b0;
	end

	 logic A_out;
    reg_8  reg_A (.*, .D(D_a), .Reset(ResetA), .Shift_In(X), .Load(Ld_A),
	               .Shift_Out(A_out), .Data_Out(A));
    reg_8  reg_B (.*, .D(D_b), .Reset(ResetB), .Shift_In(A_out), .Load(Ld_B),
	               .Shift_Out(B_out), .Data_Out(B));

endmodule


module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 8'h00;
		 else if (Load)
			  Data_Out <= D;
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
	    end
    end
	
    assign Shift_Out = Data_Out[0];

endmodule
