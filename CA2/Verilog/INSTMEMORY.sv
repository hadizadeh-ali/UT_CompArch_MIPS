module INSTMEMORY (Address, Instruction);
	input [31:0] Address;
	output logic [31:0] Instruction;
	
	logic [31:0] MEM [0:127];
	
	initial $readmemb("inst.txt", MEM);
	
	assign Instruction = MEM[Address >> 2];
endmodule