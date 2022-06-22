module CPU (clk, rst);
	input logic clk, rst;
	
	wire MemRead, MemWrite, Access, PCWrite, IorD, IRWrite, RegIn, RegDst, RegWrite,
		 ALUSrcA, ALUFunc, ZWrite, NWrite, VWrite, CWrite;
	wire [1:0] MemtoReg, ALUSrcB;
	wire [2:0] opc;
	wire[31:0] Address, WriteData, ReadData, MemDataR;
	
	MEMORY		MainMem		(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite),
							.Address(Address), .WriteData(WriteData),
							.ReadData(ReadData));
					
	Controller	MainCtrl	(.clk(clk), .rst(rst), .Access(Access), .opc(opc), .IR(MemDataR),
							.PCWrite(PCWrite), .IorD(IorD), .MemWrite(MemWrite),
							.MemRead(MemRead), .IRWrite(IRWrite), .RegIn(RegIn),
							.RegDst(RegDst), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
							.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUFunc(ALUFunc),
							.ZWrite(ZWrite), .NWrite(NWrite),
							.VWrite(VWrite), .CWrite(CWrite));

							
	DATAPATH	MainDP		(.clk(clk), .rst(rst), .RegDst(RegDst),
							.RegIn(RegIn), .RegWrite(RegWrite),
							.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
							.ALUFunc(ALUFunc), .MemWrite(MemWrite),
							.MemRead(MemRead), .MemtoReg(MemtoReg),
							.MemData(ReadData), .IorD(IorD), .PCWrite(PCWrite),
							.IRWrite(IRWrite),.ZWrite(ZWrite),
							.NWrite(NWrite), .VWrite(VWrite), .CWrite(CWrite),
							.Access(Access),.MemAddr(Address), .MemWData(WriteData), .MemDataR(MemDataR));
	
	assign opc = MemDataR[22:20];
endmodule