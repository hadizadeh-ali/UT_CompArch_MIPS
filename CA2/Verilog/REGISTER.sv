module REGISTER (clk, IN, OUT);
	input clk;
	input [31:0] IN;
	output logic [31:0] OUT;
	initial OUT = 32'b0;
	always @(posedge clk)
		OUT = IN;
endmodule