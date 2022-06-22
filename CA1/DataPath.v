module DataPath (clk, Qp1, Qsl, Qrd, Asl, Ard, Drd, Crst, Cp1, Anew, AIN, DIN, QUO, Cn, ovf, neg, zer, REM);
	parameter bitsofn = 3;
	parameter [bitsofn-1:0] n = 5;
	input clk;
	// main inputs
	input [2*n-1:0] AIN;
	input [n-1:0] DIN;
	// control inputs
	input Qp1, Qsl, Qrd, Asl, Ard, Drd, Crst, Cp1, Anew;
	// main outputs
	output [n:0] QUO, REM;
	// control outputs
	output Cn, ovf, neg, zer;
	
	wire QtoA;
	wire [n+1:0] inA, X, Y, genA;
	wire [2:0] cnt;
	wire [1:0] cnt_out, ovf_out;

	assign REM = X[n:0];
	
	// shift register for Q
	shift_register #(n+1) Q_reg(.clk(clk), .sin(1'b0), .parin({AIN[n-1:0],1'b0}),
			.p1(Qp1), .shiftl(Qsl), .ld(Qrd), .parout(QUO), .sout(QtoA));
	
	// shift register for A
	shift_register #(n+2) A_reg(.clk(clk), .sin(QtoA), .parin(inA),
			.shiftl(Asl), .ld(Ard), .parout(X));
	
	// register for D
	normal_register #(n+2) D_reg(.clk(clk), .parin({2'b00,DIN}), .ld(Drd), .parout(Y));
	
	// counter and a comparator for it
	counter #(bitsofn) C_cnt(.clk(clk), .srst(Crst), .inc(Cp1), .cnt(cnt));
	comparator #(bitsofn) cmp1(.in1(cnt), .in2(n), .out(cnt_out));
	assign Cn = &cnt_out;
	
	// comparator for checking ovf
	comparator #(n+1) cmp2(.in1(X[n+1:1]), .in2(Y[n:0]), .out(ovf_out));
	assign ovf = ovf_out[1];
	
	// mux for choosing input for A
	mux #(n+2) mux1(.in0(genA), .in1({2'b0,AIN[2*n-1:n]}), .sel(Anew), .out(inA));
	
	// subtractor
	subtractor #(n+2) sub1(.inplus(X), .inminus(Y), .out(genA), .neg(neg));
	
	// NOR gate for detecting zero
	assign zer = ~|Y[n:0];
endmodule