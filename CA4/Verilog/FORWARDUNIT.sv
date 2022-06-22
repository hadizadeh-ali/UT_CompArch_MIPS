module FORWARDUNIT (clk, rst, Inst, ForwardA, ForwardB);
	// Basic inputs
	input		clk, rst;
	// Main IO
	input	[31:11]	Inst;
	output	[ 1: 0]	ForwardA, ForwardB;
	parameter [5:0] RT = 6'b000000, ADDI = 6'b000001, SLTI = 6'b000010, LW = 6'b000011,
			SW = 6'b000100, BEQ = 6'b000101, J = 6'b000110, JR = 6'b000111,
			JAL = 6'b001000;
	wire		WRITES, WR1Out, WR2Out, Rd1_2521, Rd1_2016, Rd2_2521, Rd2_2016, isRT;
	wire	[ 1: 0]	MB1Out, MB2Out, MA1Out;
	wire	[ 4: 0]	FindRd, Rd1Out, Rd2Out;
	wire	[ 5: 0] OPC;

	assign OPC = Inst[31:26];
	assign WRITES = (OPC == RT) | (OPC == ADDI) | (OPC == SLTI) | (OPC == LW);
	assign FindRd = (OPC == RT) ? Inst[15:11] : Inst[20:16];
	REGISTER #( 1)	WR1	(.clk(clk), .rst(rst), .write(1'b1), .IN(WRITES), .OUT(WR1Out));
	REGISTER #( 1)	WR2	(.clk(clk), .rst(rst), .write(1'b1), .IN(WR1Out), .OUT(WR2Out));
	REGISTER #( 5)	Rd1	(.clk(clk), .rst(rst), .write(1'b1), .IN(FindRd), .OUT(Rd1Out));
	REGISTER #( 5)	Rd2	(.clk(clk), .rst(rst), .write(1'b1), .IN(Rd1Out), .OUT(Rd2Out));
	assign Rd1_2521 = (Rd1Out == Inst[25:21]) & WR1Out;
	assign Rd1_2016 = (Rd1Out == Inst[20:16]) & WR1Out;
	assign Rd2_2521 = (Rd2Out == Inst[25:21]) & WR2Out;
	assign Rd2_2016 = (Rd2Out == Inst[20:16]) & WR2Out;
	MUX2	#( 2)	MB1	(.A(2'b00), .B(2'b10), .S(Rd2_2016), .W(MB1Out));
	MUX2	#( 2)	MB2	(.A(MB1Out), .B(2'b01), .S(Rd1_2016), .W(MB2Out));
	assign isRT = (OPC == RT);
	MUX2	#( 2)	MB3	(.A(2'b00), .B(MB2Out), .S(isRT), .W(ForwardB));
	MUX2	#( 2)	MA1	(.A(2'b00), .B(2'b10), .S(Rd2_2521), .W(MA1Out));
	MUX2	#( 2)	MA2	(.A(MA1Out), .B(2'b01), .S(Rd1_2521), .W(ForwardA));
endmodule