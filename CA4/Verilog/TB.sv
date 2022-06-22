`timescale 1ns/1ns
module TB ();
	logic clk = 1, rst = 0;
	MIPS CPU (.clk(clk), .rst(rst));

	always #1 clk = ~clk;
	initial begin
		#1 rst = 1;
		#2 rst = 0;
		#1000 $stop;
	end
endmodule