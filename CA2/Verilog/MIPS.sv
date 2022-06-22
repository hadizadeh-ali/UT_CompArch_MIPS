module MIPS(clk);
	input logic clk;
	wire z, WriteDst, RegWrite, ALUSrc, BranchAND, MemRead, MemWrite, MemtoReg;
	wire [1:0] RegDst, Jmp;
	wire [2:0] ALUOperation;
	wire [5:0] OPC, func;
	wire [31:0] InstMemAddr, Instruction, DataMemAddr, DataMemWrite, DataMemRead;
	DATAMEMORY DM (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite),
			.Address(DataMemAddr), .WriteData(DataMemWrite),
			.ReadData(DataMemRead));
	INSTMEMORY IM (.Address(InstMemAddr), .Instruction(Instruction));
	CONTROLLER CU (.OPC(OPC), .func(func), .z(z), .RegDst(RegDst), .WriteDst(WriteDst),
			.RegWrite(RegWrite), .ALUSrc(ALUSrc), .ALUOperation(ALUOperation),
			.BranchAND(BranchAND), .Jmp(Jmp), .MemRead(MemRead),
			.MemWrite(MemWrite), .MemtoReg(MemtoReg));
	DATAPATH DP (.clk(clk), .RegDst(RegDst), .WriteDst(WriteDst), .RegWrite(RegWrite),
		.ALUSrc(ALUSrc), .ALUOperation(ALUOperation), .BranchAND(BranchAND),
		.Jmp(Jmp), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg),
		.z(z), .Inst(Instruction), .DataMemRead(DataMemRead),
		.InstMemAddr(InstMemAddr), .DataMemAddr(DataMemAddr),
		.DataMemWrite(DataMemWrite));
	assign OPC = Instruction[31:26];
	assign func = Instruction[5:0];
endmodule
