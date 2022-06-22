module comparator (in1, in2, out);
	parameter n;
	input [n-1:0] in1, in2;
	output [1:0] out;
	
	assign out = (in1>in2) ? 2'b10 :
				 (in1<in2) ? 2'b01 : 2'b11;
endmodule
