module shift_register(clk, sin, parin, p1, shiftl, ld, parout, sout);
	parameter n;
	input	clk;
	// main inputs
	input	sin;
	input	[n-1:0] parin;
	// control inputs
	input	p1, shiftl, ld;
	output	[n-1:0] parout;
	output 	sout;
	reg	sout;
	
	reg [n-1:0] data;
	
	always @(posedge clk) begin		
		if (ld)
			data <= parin;
		else if (shiftl)
			begin
			data = {data[n-2:0],sin};
			end
		else if (p1)
			data[0] = 1'b1;		
	end
	
	assign parout = data;
	assign sout = data[n-1];
	
endmodule