module DATAPATH (clk, rst, RegDst, WriteDst, RegWrite, ALUSrc, Branch, ALUOperation, Jmp,
		MemRead_ID, MemWrite_ID, MemtoReg, PCWrite, IFIDWrite, NOP, Inst_ID, ForwardA,
		ForwardB, Inst_3111, Inst, DataMemRead, MemRead, MemWrite,
		InstMemAddr, DataMemAddr, DataMemWrite, OPC, func);
	// Basic controls		
	input		clk, rst;
	// CU EX inputs
	input		ALUSrc, Branch;
	input	[ 1: 0]	RegDst, Jmp;
	input	[ 2: 0]	ALUOperation;
	// CU M inputs
	input		MemRead_ID, MemWrite_ID;
	// CU WB inputs
	input		WriteDst, RegWrite, MemtoReg;
	// CU outputs
	output	[ 5: 0]	OPC, func;
	// HU controls
	input		PCWrite, IFIDWrite, NOP;
	output	[31: 0]	Inst_ID;
	// FU controls
	input	[ 1: 0]	ForwardA, ForwardB;
	output	[31:11]	Inst_3111;
	// Peripheral ports
	input	[31: 0]	Inst, DataMemRead;
	output		MemRead, MemWrite;
	output	[31: 0]	InstMemAddr, DataMemAddr, DataMemWrite;
	
	wire 		ALUSrc_EX, Branch_EX, z, BranchAND, MemRead_EX, MemRead_MM, MemWrite_EX,
				MemWrite_MM, WriteDst_EX, WriteDst_MM, WriteDst_WB, RegWrite_EX,
				RegWrite_MM, RegWrite_WB, RegWrite_AND, MemtoReg_EX, MemtoReg_MM, MemtoReg_WB,
				NOP_EX, NOP_MM, NOP_WB;
	wire	[ 1: 0]	RegDst_EX, Jmp_EX;
	wire	[ 2: 0]	ALUOperation_EX;
	wire	[ 4: 0]	RW_EX, RW_MM, RW_WB, Inst_2016, Inst_1511;
	wire	[27: 0]	Inst_2500;
	wire	[31: 0]	PCIn, PCOut, PCp4_IF, PCp4_ID, PCp4_EX, PCp4_MM, PCp4_WB, WD, ALUMEMOut, D1_ID,
				D1_EX, D2_ID, D2_EX, D2_MM, A, B, MEX3Out, ALUOut_EX, ALUOut_MM, ALUOut_WB, PCOff, BranchOut,
				Inst_1500, DataMemRead_WB;
	
	// IF
	REGISTER	PC	(.clk(clk), .rst(rst), .write(PCWrite), .IN(PCIn), .OUT(PCOut));
	ADDER		PLUS4	(.A(PCOut), .B(32'b100), .W(PCp4_IF));
	assign		InstMemAddr = PCOut;
	assign		BranchAND = Branch_EX & z;
	MUX2	#(32)	MIF1	(.A(PCp4_IF), .B(PCOff), .S(BranchAND), .W(BranchOut));
	MUX3	#(32)	MIF2	(.A(BranchOut), .B({PCp4_ID[31:28], Inst_2500}), .C(D1_EX), .S(Jmp_EX), .W(PCIn));
	// IF/ID
	REGISTER #(32)	IFID01	(.clk(clk), .rst(rst), .write(IFIDWrite), .IN(PCp4_IF), .OUT(PCp4_ID));
	REGISTER #(32)	IFID02	(.clk(clk), .rst(rst), .write(IFIDWrite), .IN(Inst), .OUT(Inst_ID));
	// ID
	REGFILE		RF	(.clk(clk), .rst(rst), .RegWrite(RegWrite_AND), .R1(Inst_ID[25:21]),
					.R2(Inst_ID[20:16]), .RW(RW_WB), .WD(WD), .D1(D1_ID),
					.D2(D2_ID));
	assign OPC = Inst_ID[31:26];
	assign func = Inst_ID[5:0];
	// ID/EX
	REGISTER #( 1)	IDEX01	(.clk(clk), .rst(rst), .write(1'b1), .IN(ALUSrc), .OUT(ALUSrc_EX));
	REGISTER #( 1)	IDEX02	(.clk(clk), .rst(rst), .write(1'b1), .IN(Branch), .OUT(Branch_EX));
	REGISTER #( 2)	IDEX03	(.clk(clk), .rst(rst), .write(1'b1), .IN(RegDst), .OUT(RegDst_EX));
	REGISTER #( 2)	IDEX04	(.clk(clk), .rst(rst), .write(1'b1), .IN(Jmp), .OUT(Jmp_EX));
	REGISTER #( 3)	IDEX05	(.clk(clk), .rst(rst), .write(1'b1), .IN(ALUOperation), .OUT(ALUOperation_EX));
	REGISTER #( 1)	IDEX06	(.clk(clk), .rst(rst), .write(1'b1), .IN(MemRead_ID), .OUT(MemRead_EX));
	REGISTER #( 1)	IDEX07	(.clk(clk), .rst(rst), .write(1'b1), .IN(MemWrite_ID), .OUT(MemWrite_EX));
	REGISTER #( 1)	IDEX08	(.clk(clk), .rst(rst), .write(1'b1), .IN(WriteDst), .OUT(WriteDst_EX));
	REGISTER #( 1)	IDEX09	(.clk(clk), .rst(rst), .write(1'b1), .IN(RegWrite), .OUT(RegWrite_EX));
	REGISTER #( 1)	IDEX10	(.clk(clk), .rst(rst), .write(1'b1), .IN(MemtoReg), .OUT(MemtoReg_EX));
	REGISTER #( 1)	IDEX11	(.clk(clk), .rst(rst), .write(1'b1), .IN(NOP), .OUT(NOP_EX));
	REGISTER #(32)	IDEX12	(.clk(clk), .rst(rst), .write(1'b1), .IN(PCp4_ID), .OUT(PCp4_EX));
	REGISTER #(28)	IDEX13	(.clk(clk), .rst(rst), .write(1'b1), .IN({Inst_ID[25:0], 2'b0}), .OUT(Inst_2500));
	REGISTER #(32)	IDEX14	(.clk(clk), .rst(rst), .write(1'b1), .IN(D1_ID), .OUT(D1_EX));
	REGISTER #(32)	IDEX15	(.clk(clk), .rst(rst), .write(1'b1), .IN(D2_ID), .OUT(D2_EX));
	REGISTER #(32)	IDEX16	(.clk(clk), .rst(rst), .write(1'b1), .IN({{16{Inst_ID[15]}}, Inst_ID[15:0]}), .OUT(Inst_1500));
	REGISTER #(21)	IDEX17	(.clk(clk), .rst(rst), .write(1'b1), .IN(Inst_ID[31:11]), .OUT(Inst_3111));
	REGISTER #( 5)	IDEX18	(.clk(clk), .rst(rst), .write(1'b1), .IN(Inst_ID[20:16]), .OUT(Inst_2016));
	REGISTER #( 5)	IDEX19	(.clk(clk), .rst(rst), .write(1'b1), .IN(Inst_ID[15:11]), .OUT(Inst_1511));
	// EX
	ADDER		PLUSOFF	(.A(PCp4_EX), .B({Inst_1500[29:0], 2'b0}), .W(PCOff));
	MUX3	#(32)	MEX2	(.A(D1_EX), .B(ALUOut_MM), .C(ALUMEMOut), .S(ForwardA), .W(A));
	MUX2	#(32)	MEX3	(.A(D2_EX), .B(Inst_1500), .S(ALUSrc_EX), .W(MEX3Out));
	MUX3	#(32)	MEX4	(.A(MEX3Out), .B(ALUOut_MM), .C(ALUMEMOut), .S(ForwardB), .W(B));
	ALU		ALU1	(.A(A), .B(B), .F(ALUOperation_EX), .W(ALUOut_EX), .z(z));
	MUX3	#( 5)	MEX1	(.A(Inst_2016), .B(Inst_1511), .C(5'b11111), .S(RegDst_EX), .W(RW_EX));
	// EX/MEM
	REGISTER #( 1)	EXMM01	(.clk(clk), .rst(rst), .write(1'b1), .IN(MemRead_EX), .OUT(MemRead_MM));
	REGISTER #( 1)	EXMM02	(.clk(clk), .rst(rst), .write(1'b1), .IN(MemWrite_EX), .OUT(MemWrite_MM));
	REGISTER #( 1)	EXMM03	(.clk(clk), .rst(rst), .write(1'b1), .IN(WriteDst_EX), .OUT(WriteDst_MM));
	REGISTER #( 1)	EXMM04	(.clk(clk), .rst(rst), .write(1'b1), .IN(RegWrite_EX), .OUT(RegWrite_MM));
	REGISTER #( 1)	EXMM05	(.clk(clk), .rst(rst), .write(1'b1), .IN(MemtoReg_EX), .OUT(MemtoReg_MM));
	REGISTER #( 1)	EXMM06	(.clk(clk), .rst(rst), .write(1'b1), .IN(NOP_EX), .OUT(NOP_MM));
	REGISTER #(32)	EXMM07	(.clk(clk), .rst(rst), .write(1'b1), .IN(PCp4_EX), .OUT(PCp4_MM));
	REGISTER #(32)	EXMM08	(.clk(clk), .rst(rst), .write(1'b1), .IN(ALUOut_EX), .OUT(ALUOut_MM));
	REGISTER #(32)	EXMM09	(.clk(clk), .rst(rst), .write(1'b1), .IN(D2_EX), .OUT(D2_MM));
	REGISTER #( 5)	EXMM10	(.clk(clk), .rst(rst), .write(1'b1), .IN(RW_EX), .OUT(RW_MM));
	// MEM
	assign DataMemAddr = ALUOut_MM;
	assign DataMemWrite = D2_MM;
	assign MemRead = MemRead_MM;
	assign MemWrite = MemWrite_MM & ~NOP_MM;
	// MEM/WB
	REGISTER #( 1)	MMWB01	(.clk(clk), .rst(rst), .write(1'b1), .IN(WriteDst_MM), .OUT(WriteDst_WB));
	REGISTER #( 1)	MMWB02	(.clk(clk), .rst(rst), .write(1'b1), .IN(RegWrite_MM), .OUT(RegWrite_WB));
	REGISTER #( 1)	MMWB03	(.clk(clk), .rst(rst), .write(1'b1), .IN(MemtoReg_MM), .OUT(MemtoReg_WB));
	REGISTER #( 1)	MMWB04	(.clk(clk), .rst(rst), .write(1'b1), .IN(NOP_MM), .OUT(NOP_WB));
	REGISTER #(32)	MMWB05	(.clk(clk), .rst(rst), .write(1'b1), .IN(PCp4_MM), .OUT(PCp4_WB));
	REGISTER #(32)	MMWB06	(.clk(clk), .rst(rst), .write(1'b1), .IN(DataMemRead), .OUT(DataMemRead_WB));
	REGISTER #(32)	MMWB07	(.clk(clk), .rst(rst), .write(1'b1), .IN(ALUOut_MM), .OUT(ALUOut_WB));
	REGISTER #( 5)	MMWB08	(.clk(clk), .rst(rst), .write(1'b1), .IN(RW_MM), .OUT(RW_WB));
	// WB
	MUX2 #(32)	M6	(.A(DataMemRead_WB), .B(ALUOut_WB), .S(MemtoReg_WB), .W(ALUMEMOut));
	MUX2 #(32)	M2 	(.A(ALUMEMOut), .B(PCp4_WB), .S(WriteDst_WB), .W(WD));
	assign RegWrite_AND = RegWrite_WB & ~NOP_WB;
endmodule