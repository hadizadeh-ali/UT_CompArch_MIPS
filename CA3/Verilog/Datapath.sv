module DATAPATH (clk, rst, RegDst, RegIn, RegWrite, ALUSrcA, ALUSrcB, ALUFunc, MemWrite, MemRead, MemtoReg,
				MemData, IorD, PCWrite, IRWrite, 
				ZWrite, NWrite, VWrite, CWrite, ZR, NR, VR, CR, Access,
				MemAddr, MemWData, MemDataR);
	input		clk, rst;
	input		RegDst, RegIn, RegWrite, ALUSrcA, ALUFunc, IorD, PCWrite,
				IRWrite, ZWrite, NWrite, VWrite, CWrite;
	input [1:0]	ALUSrcB;
	input [1:0]	MemtoReg;
	output		ZR, NR, VR, CR, Access, MemRead, MemWrite;
	input [31:0] MemData;
	output [31:0] MemAddr, MemWData, MemDataR;
	
	wire [31:0]	PCOut, ALUOut,  WD, D1, D2, ALUA, ALUB, ALUB1, ALUB3;
	wire [3:0] 	R1, R2, RW;
	wire [2:0] ALUOp;
	wire z, n, v, c;
	
	Register	#(32)	PC	(.clk(clk), .rst(rst), .parin(ALUOut), .ld(PCWrite), .parout(PCOut));
	mux2		#(32)	M1	(.in0(PCOut), .in1(ALUOut), .sel(IorD), .out(MemAddr));
	Register	#(32)	IR	(.clk(clk), .rst(rst), .parin(MemData), .ld(IRWrite), .parout(MemDataR));
	
	mux2		#(4)	M2	(.in0(MemDataR[3:0]), .in1(MemDataR[15:12]), .sel(RegIn), .out(R2));
	mux2		#(4)	M3	(.in0(MemDataR[15:12]), .in1(4'b1111), .sel(RegDst), .out(RW));
	mux4		#(32)	M4	(.in0(ALUOut), .in1(MemData), .in2(PCOut), .sel(MemtoReg), .out(WD));
	REGFILE 			RF	(.clk(clk), .rst(rst), .RegWrite(RegWrite), .R1(R1), .R2(R2), .RW(RW), .WD(WD), .D1(D1), .D2(D2));	
	
	mux2		#(32)	M5	(.in0(PCOut), .in1(D1), .sel(ALUSrcA), .out(ALUA));
	SignExtend	#(12)	SE1	(.in(MemDataR[11:0]), .out(ALUB1));
	SignExtend	#(26) 	SE2	(.in(MemDataR[25:0]), .out(ALUB3));
	mux4 		#(32)	M6	(.in0(D2), .in1(ALUB1), .in2(1), .in3(ALUB3), .sel(ALUSrcB), .out(ALUB));
	mux2 		#(3)	M7	(.in0(0), .in1(MemDataR[22:20]), .sel(ALUFunc), .out(ALUOp));
	ALU					ALU1(.A(ALUA), .B(ALUB), .ALUOP(ALUOp), .W(ALUOut), .z(z), .n(n), .v(v), .c(c));
	Register	#(1)	Z	(.clk(clk), .rst(rst), .parin(z), .ld(ZWrite), .parout(ZR));
	Register	#(1)	N	(.clk(clk), .rst(rst), .parin(n), .ld(NWrite), .parout(NR));
	Register	#(1)	V	(.clk(clk), .rst(rst), .parin(v), .ld(VWrite), .parout(VR));
	Register	#(1)	C	(.clk(clk), .rst(rst), .parin(c), .ld(CWrite), .parout(CR));
	
	//Register	#(1)	A	(.clk(clk), .rst(rst), .parin(Access), .parout(AR));

	
	/*assign Access = ((MemDataR[31])&(MemDataR[30]))|
					(~(MemDataR[31])&~(MemDataR[30])&(ZR))|
					(~(MemDataR[30])&(MemDataR[31])&~(ZR)&~(NR^VR))|
					((NR^VR)&~(MemDataR[30])&~(MemDataR[31]));
	
	assign Access = (((MemDataR[31])&(MemDataR[30]))|
					(~(MemDataR[31])&~(MemDataR[30])&(ZR))|
					(~(MemDataR[30])&(MemDataR[31])&((NR&~VR)|(~NR&VR)))|
					((MemDataR[30])&~(MemDataR[31])&(~ZR)&((NR&VR)|(~NR&~VR))));*/
	
	assign Access = ((MemDataR[31])&(MemDataR[30]))|
					(~(MemDataR[31])&~(MemDataR[30])&(ZR))|
					(~(MemDataR[31])&(MemDataR[30])&~(ZR)&~(NR^VR))|
					((NR^VR)&(MemDataR[31])&~(MemDataR[30]));
					
					
	assign R1 = MemDataR[19:16];
	assign MemWData = D2;
endmodule