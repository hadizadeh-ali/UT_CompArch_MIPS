module MUX3 (A, B, C, S, W);
	parameter n;
	input [n-1:0] A, B, C;
	input [1:0] S;
	output [n-1:0] W;
	assign W = (S == 2'b0) ? A : (S == 2'b1) ? B : C;
endmodule

