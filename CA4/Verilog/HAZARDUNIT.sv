module HAZARDUNIT (clk, rst, Inst, PCWrite, IFIDWrite, NOP);
	// Basic inputs
	input		clk, rst;
	// Main IO
	input	[31: 0]	Inst;
	output		PCWrite, IFIDWrite, NOP;
	
	wire		isLW, isRT, instOR, S1Out, S2Out, LWOut, Rdis2521, Rdis2016, Rdhazard,
				NOut;
	wire	[ 4: 0]	RdIn, RdOut;
	parameter 	OPC_RT = 6'b000000, OPC_LW = 6'b000011;

	assign isLW = (Inst[31:26] == OPC_LW);
	assign isRT = (Inst[31:26] == OPC_RT);
	assign instOR = |Inst[31:26];	// inst is RT
	REGISTER #(1)	S1	(.clk(clk), .rst(rst), .write(1'b1), .IN(1'b1), .OUT(S1Out));
	REGISTER #(1)	S2	(.clk(clk), .rst(rst), .write(1'b1), .IN(S1Out), .OUT(S2Out));
	REGISTER #(1)	LW	(.clk(clk), .rst(rst), .write(1'b1), .IN(isLW), .OUT(LWOut));
	MUX2	#(5)	M1	(.A(Inst[20:16]), .B(Inst[15:11]), .S(isRT), .W(RdIn));
	REGISTER #(5)	Rd	(.clk(clk), .rst(rst), .write(1'b1), .IN(RdIn), .OUT(RdOut));
	assign Rdis2521 = (RdOut == Inst[25:21]);
	assign Rdis2016 = (RdOut == Inst[20:16]);
	assign Rdhazard = Rdis2521 | (Rdis2016 & isRT);
	REGISTER #(1)	N	(.clk(clk), .rst(rst), .write(1'b1), .IN(NOP), .OUT(NOut));
	assign NOP = S2Out & LWOut & Rdhazard & ~NOut;
	assign IFIDWrite = ~NOP;
	assign PCWrite = ~NOP;
endmodule