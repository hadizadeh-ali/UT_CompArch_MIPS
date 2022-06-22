module normal_register(clk, parin, ld, parout);
	parameter n;
	input clk;
	// main inputs
	input [6:0] parin;
	// control inputs
	input ld;
	output	[n-1:0] parout;
	reg	[n-1:0] parout;
	
	reg [n-1:0] data;
	
	always @(posedge clk) begin
		if (ld)
			data <= parin;
	end
	
	assign parout = data;
	
endmodule
