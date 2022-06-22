module subtractor (inplus, inminus, out, neg);
	parameter n;
	input [n-1:0] inplus, inminus;
	output [n-1:0] out;
	output neg;
	
	wire [n-1:0] t_comp;
	
	assign t_comp = ~inminus + 1;
	assign out = inplus + t_comp;
	assign neg = out[n-1];
endmodule