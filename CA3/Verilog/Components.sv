module Register(clk, rst, parin, ld, parout);
	parameter n = 32;
	input clk, rst;
	// main inputs
	input [n-1:0] parin;
	// control inputs
	input ld;
	output	[n-1:0] parout;
	reg	[n-1:0] parout;
	
	always @(posedge clk, posedge rst) begin
		if(rst)
			parout <= 0;
		else if (ld)
			parout <= parin;
	end
	
endmodule

module mux2 (in0, in1, sel, out);
	parameter n = 32;
	// main inputs
	input [n-1:0] in0, in1;
	// control inputs
	input sel;
	output [n-1:0] out;

	assign out = sel ? in1 : in0;
endmodule

module mux4 (in0, in1, in2, in3, sel, out);
	parameter n = 32;
	// main inputs
	input [n-1:0] in0, in1, in2, in3;
	// control inputs
	input [1:0] sel;
	output [n-1:0] out;

	assign out = sel[1] ? (sel[0] ? in3 : in2) : (sel[0] ? in1 : in0);
endmodule

module MEMORY (clk, MemRead, MemWrite, Address, WriteData, ReadData);
	input clk, MemRead, MemWrite;
	input [31:0] Address, WriteData;
	output logic [31:0] ReadData;
	
	logic [31:0] MEM [0:2004];
	
	initial $readmemb("data.txt", MEM, 0);
	
	//assign ReadData = MemRead ? MEM[Address] : 32'bz;
	assign ReadData = MEM[Address];
	always @(posedge clk)
		if (MemWrite)
			MEM[Address] = WriteData;
endmodule

module REGFILE (clk, rst, RegWrite, R1, R2, RW, WD, D1, D2);
	input clk, rst;
	input RegWrite;
	input [3:0] R1, R2, RW;
	input [31:0] WD;
	output [31:0] D1, D2;
	
	logic [31:0] MEM [0:15];
	
	assign D1 = MEM[R1];
	assign D2 = MEM[R2];
	
	logic [3:0] i;
	
	always @(posedge clk, posedge rst) begin
		if(rst)
			begin
				i = 0;
				repeat (16) begin
					MEM[i] = 0;
					i = i + 1;
				end
			end
		else if (RegWrite == 1'b1) MEM[RW] = WD;
	end
endmodule

module ALU(A, B, ALUOP, W, z, n, v, c);
	input signed [31:0] A, B;
	input [2:0] ALUOP;
	output logic [31:0] W;
	output logic z, n, v, c;
	always @(A, B, ALUOP) begin
		case (ALUOP)
			3'b000:		{c,W} = A + B;
			3'b001:		{c,W} = A - B;
			3'b010:		{c,W} = A - B;
			3'b011: 	{c,W} = A & B;
			3'b100:		{c,W} = -B;
			3'b101:		{c,W} = A & B;
			3'b110:		{c,W} = A - B;
			3'b111:		{c,W} =  B;
			default:	{c,W} = 33'b0;
		endcase
	end
	assign z = ~|W;
	assign n = W[31];
	assign v = (A[31]&B[31]&~W[31]) | (~A[31]&~B[31]&W[31]);
endmodule

module SignExtend (in, out);
	parameter n=5;
	input [n-1:0] in;
	output [31:0] out;
	
	assign out[n-1:0] = in[n-1:0];
	assign out[31:n]  = {(32-n){in[n-1]}};
endmodule