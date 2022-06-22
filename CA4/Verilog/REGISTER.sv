module REGISTER (clk, rst, write, IN, OUT);
	parameter n = 32;
	input clk, rst;
	input write;
	input [n-1:0] IN;
	output logic [n-1:0] OUT;
	always @(posedge clk, posedge rst)
		if (rst) OUT = 0;
		else if (write) OUT = IN;
endmodule