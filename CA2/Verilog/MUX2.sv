module MUX2 (A, B, S, W);
	parameter n;
	input [n-1:0] A, B;
	input S;
	output [n-1:0] W;
	assign W = (S == 1'b0) ? A : B;
endmodule
