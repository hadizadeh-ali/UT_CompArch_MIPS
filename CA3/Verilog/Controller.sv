module Controller  (clk, rst, Access, opc, IR, PCWrite, IorD, MemWrite, MemRead, IRWrite, RegIn,
					RegDst, MemtoReg, RegWrite, ALUSrcA, ALUSrcB, ALUFunc, ZWrite,
					NWrite, VWrite, CWrite);
	input clk, rst;
	// control inputs
	input Access;
	input [2:0] opc;
	input [31:0] IR;
	output reg PCWrite, IorD, MemWrite, MemRead, IRWrite, RegIn, RegDst;
	output reg RegWrite, ALUSrcA, ALUFunc, ZWrite, NWrite, VWrite, CWrite;
	output reg [1:0] MemtoReg, ALUSrcB;
	wire I, L;
	
	reg [3:0] pstate, nstate;
	parameter [3:0]	
			ReadIns	= 0,
			Decode 	= 1,
			Proc012	= 2,
			Proc347	= 3,
			Proc56	= 4,
			LOAD	= 5,
			STORE	= 6,
			B		= 7,
			Start	= 8;
	
	assign I = IR[23];		
	assign L = IR[26];
	
	
	// nstate
	always @(pstate, opc, IR) begin
		case(pstate)
			Start:		nstate = ReadIns;
			ReadIns:	nstate = Decode;
			Decode:		nstate = ~Access?ReadIns:
								 ({IR[29],IR[28]} == 2'b00 & (opc==0 | opc==1 | opc==2))?Proc012:
								 ({IR[29],IR[28]} == 2'b00 & (opc==3 | opc==4 | opc==5))?Proc347:
								 ({IR[29],IR[28]} == 2'b00 & (opc==5 | opc==6))?Proc56:
								 ({IR[28],IR[20]} == 2'b10)?LOAD:
								 ({IR[28],IR[20]} == 2'b11)?STORE:
								 (IR[29] == 1)?B:
								 ReadIns;
			Proc012:	nstate = ReadIns;
			Proc347:	nstate = ReadIns;
			Proc56:		nstate = ReadIns;
			LOAD:		nstate = ReadIns;
			STORE:		nstate = ReadIns;
			B:			nstate = ReadIns;
		endcase
	end
	// control outputs
	always @(pstate) begin
		{PCWrite, IorD, MemWrite, MemRead, IRWrite, RegIn, RegDst, MemtoReg, RegWrite, ALUSrcA, ALUSrcB, ALUFunc, ZWrite, NWrite, VWrite, CWrite} = 0;
		
		case(pstate)
			Start:		;
			ReadIns:	begin IorD=0; MemRead=1; IRWrite=1; ALUSrcA=0; ALUSrcB=2; ALUFunc=0; PCWrite=1; end
			Decode:		;
			Proc012:	begin ZWrite=1; CWrite=1; NWrite=1; VWrite=1; ALUSrcA=1; ALUSrcB=I; ALUFunc=1; RegDst=0; MemtoReg=0; RegWrite=1; end
			Proc347:	begin ZWrite=1; NWrite=1; ALUSrcA=1; ALUSrcB=I; ALUFunc=1; RegDst=1; MemtoReg=0; RegWrite=1; end
			Proc56:		begin ZWrite=1; CWrite=1; NWrite=~opc[0]; VWrite=~opc[0]; ALUFunc=1; ALUSrcA=1; ALUSrcB=I; end
			LOAD:		begin ALUSrcA=1; ALUSrcB=1; ALUFunc=0; IorD=1; MemRead=1; RegDst=0; MemtoReg=1; RegWrite=1; end
			STORE:		begin ALUSrcA=1; ALUSrcB=1; ALUFunc=0; IorD=1; MemWrite=1; RegIn=1; end
			B:			begin ALUSrcA=0; ALUSrcB=3; ALUFunc=0; PCWrite=1; MemtoReg=2; RegDst=1; RegWrite=L; end
		endcase
	end
	// pstate
	always @(posedge clk, posedge rst) begin
		if(rst)
			pstate <= Start;
		else
			pstate <= nstate;
	end
endmodule