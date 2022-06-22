module REGFILE (clk, RegWrite, R1, R2, RW, WD, D1, D2);
	input clk;
	input RegWrite;
	input [4:0] R1, R2, RW;
	input [31:0] WD;
	output [31:0] D1, D2;
	
	logic [31:0] MEM [0:31];
	
	assign D1 = MEM[R1];
	assign D2 = MEM[R2];
	
	logic [4:0] i = 0;
	initial repeat (32) begin
		MEM[i] = 0;
		i = i + 1;
	end
	
	always @(posedge clk) begin
		if (RegWrite == 1'b1) MEM[RW] = WD;
	end
endmodule