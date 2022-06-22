module mux (in0, in1, sel, out);
	parameter n;
	// main inputs
	input [6:0] in0, in1;
	// control inputs
	input sel;
	output [6:0] out;

	assign out = sel ? in1 : in0;
endmodule
