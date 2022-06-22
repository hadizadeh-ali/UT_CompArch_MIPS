`timescale 1ns/1ns;
module Testbench();
	logic clk = 0;
	MIPS Processor (.clk(clk));
	initial repeat (3000) #2 clk = ~clk;
endmodule
