module ADDER (A, B, W);
	input [31:0] A, B;
	output [31:0] W;
	assign W = A + B;
endmodule
