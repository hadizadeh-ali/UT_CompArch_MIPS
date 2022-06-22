module DATAPATH (clk, RegDst, WriteDst, RegWrite, ALUSrc, ALUOperation, BranchAND, Jmp,
		MemRead, MemWrite, MemtoReg, z, Inst, DataMemRead, InstMemAddr, DataMemAddr,
		DataMemWrite);
	input		clk;
	input		WriteDst, RegWrite, ALUSrc, BranchAND, MemRead, MemWrite, MemtoReg;
	input [1:0]	RegDst, Jmp;
	input [2:0]	ALUOperation;
	output		z;
	input [31:0]	Inst, DataMemRead;
	output [31:0]	InstMemAddr, DataMemAddr, DataMemWrite;
	
	wire [31:0]	PCIn, PCOut, PCp4, WD, ALUMEMOut, D1, D2, B, ALUOut, PCOff,
				branchOut;
	wire [4:0] 	RW;
	
	REGISTER	PC	(.clk(clk), .IN(PCIn), .OUT(PCOut));
	ADDER		PLUS4	(.A(PCOut), .B(32'b100), .W(PCp4));
	assign		InstMemAddr = PCOut;
	MUX3 #(5)	M1	(.A(Inst[20:16]), .B(Inst[15:11]), .C(5'b11111), .S(RegDst),
					.W(RW));
	MUX2 #(32)	M2 	(.A(ALUMEMOut), .B(PCp4), .S(WriteDst), .W(WD));
	REGFILE		RF	(.clk(clk), .RegWrite(RegWrite), .R1(Inst[25:21]),
					.R2(Inst[20:16]), .RW(RW), .WD(WD), .D1(D1),
					.D2(D2));
	MUX2 #(32)	M3	(.A(D2), .B({16'b0, Inst[15:0]}), .S(ALUSrc), .W(B));
	ALU		ALU1	(.A(D1), .B(B), .F(ALUOperation), .W(ALUOut), .z(z));
	ADDER		PLUSOFF	(.A(PCp4), .B({{14{Inst[15]}}, Inst[15:0], 2'b0}), .W(PCOff));
	MUX2 #(32)	M4	(.A(PCp4), .B(PCOff), .S(BranchAND), .W(branchOut));
	MUX3 #(32)	M5	(.A(branchOut), .B({PCp4[31:28], Inst[25:0], 2'b0}),
					.C(D1), .S(Jmp), .W(PCIn));
	assign DataMemAddr = ALUOut;
	assign DataMemWrite = D2;
	MUX2 #(32)	M6	(.A(DataMemRead), .B(ALUOut), .S(MemtoReg), .W(ALUMEMOut));
endmodule