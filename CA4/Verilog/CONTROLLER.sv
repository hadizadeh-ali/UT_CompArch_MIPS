module CONTROLLER (clk, rst, OPC, func, Branch, RegDst, WriteDst, RegWrite, ALUSrc, ALUOperation,
			Jmp, MemRead_ID, MemWrite_ID, MemtoReg);
	input		clk, rst;
	input	[ 5: 0]	OPC, func;
	output		Branch, WriteDst, RegWrite, ALUSrc, MemRead_ID, MemWrite_ID, MemtoReg;
	logic		Branch, WriteDst, RegWrite, ALUSrc, MemRead_ID, MemWrite_ID, MemtoReg;
	output	[ 1: 0]	RegDst, Jmp;
	logic	[ 1: 0]	RegDst, Jmp;
	output	[ 2: 0]	ALUOperation;
	logic	[ 2: 0]	ALUOperation;
	
	logic		ACTIVE;
	logic	[ 1: 0]	ALUOP;
	
	parameter [5:0] RT = 6'b000000, ADDI = 6'b000001, SLTI = 6'b000010, LW = 6'b000011,
			SW = 6'b000100, BEQ = 6'b000101, J = 6'b000110, JR = 6'b000111,
			JAL = 6'b001000;

	always @(OPC) begin
		{RegDst, WriteDst, RegWrite, ALUSrc, ALUOP, Branch, Jmp, MemRead_ID,
			MemWrite_ID, MemtoReg} = 0;
		case (OPC)
			RT:	begin	RegDst = 2'b01; ALUOP = 2'b10;
					RegWrite = ACTIVE; MemtoReg = 1;
				end
			ADDI:	begin	ALUSrc = 1;
					RegWrite = ACTIVE; MemtoReg = 1;
				end
			SLTI:	begin	ALUSrc = 1; ALUOP = 2'b11;
					RegWrite = ACTIVE; MemtoReg = 1;
				end
			LW:	begin	ALUSrc = 1;
					MemRead_ID = ACTIVE;
					RegWrite = ACTIVE;
				end
			SW:	begin	ALUSrc = 1;
					MemWrite_ID = ACTIVE;
				end
			BEQ:	begin	ALUOP = 2'b01;
					Branch = 1;
				end
			J:	begin	Jmp = 2'b01;
				end
			JR:	begin	Jmp = 2'b10;
				end
			JAL:	begin	RegDst = 2'b10;
					Jmp = 1;
					WriteDst = 1; RegWrite = ACTIVE;
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

	always @(posedge clk, posedge rst) begin
		if (rst)	ACTIVE = 0;
		else		ACTIVE = 1;
	end
endmodule
