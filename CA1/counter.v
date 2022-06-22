module counter (clk, srst, inc, cnt); 
	parameter n; 
	input clk; 
	// control inputs 
	input srst, inc; 
	output [n-1:0] cnt; 
	reg [n-1:0] cnt; 

	always @(posedge clk) 
		if(srst) 
			cnt <= 0; 
		else if (inc)
			cnt <= cnt + 1'b1;
endmodule