`timescale 1ns/1ns

module TB();
	logic clk = 0, rst = 0;

	CPU ARM(.clk(clk), .rst(rst));
	
	initial begin
		#1 rst = 1; clk = 1;
		repeat (3) #1 clk = ~clk;
		rst = 0;
		#1 clk = 1;
		repeat (1000) #1 clk = ~clk;
	end
endmodule