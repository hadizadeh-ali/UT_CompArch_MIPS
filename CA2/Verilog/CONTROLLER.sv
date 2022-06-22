module CONTROLLER (OPC, func, z, RegDst, WriteDst, RegWrite, ALUSrc, ALUOperation,
			BranchAND, Jmp, MemRead, MemWrite, MemtoReg);
	input [5:0] OPC, func;
	input z;
	output logic WriteDst, RegWrite, ALUSrc, BranchAND, MemRead, MemWrite, MemtoReg;
	output logic [1:0] RegDst, Jmp;
	output logic [2:0] ALUOperation;
	logic [1:0] ALUOP, branch;
	
	always @(OPC) begin
		{RegDst, WriteDst, RegWrite, ALUSrc, ALUOP, branch, Jmp, MemRead,
			MemWrite, MemtoReg} = 0;
		case (OPC)
			6'b000000:	begin	RegDst = 1; RegWrite = 1; ALUOP = 2'b10;
						MemtoReg = 1;
					end
			6'b000001:	begin	RegWrite = 1; ALUSrc = 1; MemtoReg = 1;
					end
			6'b000010:	begin	RegWrite = 1; ALUSrc = 1; ALUOP = 2'b11;
						MemtoReg = 1;
					end
			6'b000011:	begin	RegWrite = 1; ALUSrc = 1; MemRead = 1;
					end
			6'b000100:	begin	ALUSrc = 1; MemWrite = 1;
					end
			6'b000101:	begin	ALUOP = 2'b01; branch = 1;
					end
			6'b000110:	begin	Jmp = 1;
					end
			6'b000111:	begin	Jmp = 2;
					end
			6'b001000:	begin	RegDst = 2; WriteDst = 1; RegWrite = 1;
						Jmp = 1;
					end
		endcase
	end
	always @(ALUOP, func) begin
		ALUOperation = 3'b000;
		if (ALUOP == 2'b00)		ALUOperation = 3'b010;
		else if (ALUOP == 2'b01)	ALUOperation = 3'b011;
		else if (ALUOP == 2'b10)
			case (func)
				6'b000001:	ALUOperation = 3'b010;
				6'b000010:	ALUOperation = 3'b011;
				6'b000100:	ALUOperation = 3'b000;
				6'b001000:	ALUOperation = 3'b001;
				6'b010000:	ALUOperation = 3'b111;
			endcase
		else				ALUOperation = 3'b111;
	end
	assign BranchAND = z & branch;
endmodule
