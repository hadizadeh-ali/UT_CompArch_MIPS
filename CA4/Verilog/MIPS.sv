module MIPS (clk, rst);
	input		clk, rst;
	wire		ALUSrc, Branch, MemRead_ID, MemWrite_ID, WriteDst, RegWrite, MemtoReg, PCWrite, IFIDWrite, NOP, MemRead, MemWrite;
	wire	[ 1: 0]	RegDst, Jmp, ForwardA, ForwardB;
	wire	[ 2: 0]	ALUOperation;
	wire	[ 5: 0]	OPC, func;
	wire	[31: 0]	Inst_ID, InstMemAddr, DataMemRead, DataMemAddr, DataMemWrite, Inst;
	wire	[31:11]	Inst_3111;
	DATAPATH	DP	(.clk(clk), .rst(rst), .RegDst(RegDst), .WriteDst(WriteDst), .RegWrite(RegWrite), .ALUSrc(ALUSrc), .Branch(Branch),
				.ALUOperation(ALUOperation), .Jmp(Jmp), .MemRead_ID(MemRead_ID), .MemWrite_ID(MemWrite_ID), .MemtoReg(MemtoReg),
				.PCWrite(PCWrite), .IFIDWrite(IFIDWrite), .NOP(NOP), .Inst_ID(Inst_ID), .ForwardA(ForwardA), .ForwardB(ForwardB),
				.Inst_3111(Inst_3111), .Inst(Inst), .DataMemRead(DataMemRead), .MemRead(MemRead), .MemWrite(MemWrite),
				.InstMemAddr(InstMemAddr), .DataMemAddr(DataMemAddr), .DataMemWrite(DataMemWrite), .OPC(OPC), .func(func));
	CONTROLLER	CU	(.clk(clk), .rst(rst), .OPC(OPC), .func(func), .Branch(Branch), .RegDst(RegDst), .WriteDst(WriteDst), .RegWrite(RegWrite),
				.ALUSrc(ALUSrc), .ALUOperation(ALUOperation), .Jmp(Jmp), .MemRead_ID(MemRead_ID), .MemWrite_ID(MemWrite_ID),
				.MemtoReg(MemtoReg));
	HAZARDUNIT	HU	(.clk(clk), .rst(rst), .Inst(Inst_ID), .PCWrite(PCWrite), .IFIDWrite(IFIDWrite), .NOP(NOP));
	FORWARDUNIT	FU	(.clk(clk), .rst(rst), .Inst(Inst_3111), .ForwardA(ForwardA), .ForwardB(ForwardB));
	INSTMEMORY 	IM	(.Address(InstMemAddr), .Instruction(Inst));
	DATAMEMORY	DM	(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .Address(DataMemAddr), .WriteData(DataMemWrite),
				.ReadData(DataMemRead));
endmodule