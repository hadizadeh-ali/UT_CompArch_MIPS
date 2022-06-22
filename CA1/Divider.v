module Divider (clk, rst, start, finish, AIN, DIN, QUO, REM, divby0, overflow);
	input clk;
	// control inputs
	input rst, start, finish;
	// main inputs
	input [9:0] AIN;
	input [4:0] DIN;
	output divby0, overflow;
	output [5:0] QUO, REM;

	wire Qp1, Qsl, Qrd, Asl, Ard, Drd, Crst, Cp1, Anew, Cn, ovf, neg, zer, d;
	Controller CU(.clk(clk), .rst(rst), .start(start), .Qp1(Qp1), .Qsl(Qsl),
		.Qrd(Qrd), .Asl(Asl), .Ard(Ard), .Drd(Drd), .Crst(Crst), .Cp1(Cp1),
		.Anew(Anew), .Cn(Cn), .ovf(ovf), .neg(neg), .zer(zer),
		.divby0(divby0), .overflow(overflow), .finish(finish));
	DataPath DP(.clk(clk), .Qp1(Qp1), .Qsl(Qsl), .Qrd(Qrd), .Asl(Asl), .Ard(Ard),
		.Drd(Drd), .Crst(Crst), .Cp1(Cp1), .Anew(Anew), .AIN(AIN), .DIN(DIN),
		.QUO(QUO), .Cn(Cn), .ovf(ovf), .neg(neg), .zer(zer), .REM(REM));
endmodule