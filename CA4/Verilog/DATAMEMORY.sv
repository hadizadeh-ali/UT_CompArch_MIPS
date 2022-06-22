module DATAMEMORY (clk, MemRead, MemWrite, Address, WriteData, ReadData);
	input clk, MemRead, MemWrite;
	input [31:0] Address, WriteData;
	output logic [31:0] ReadData;
	
	logic [31:0] MEM [250:700];
	
	initial $readmemb("data.txt", MEM, 250);
	
	assign ReadData = MemRead ? MEM[Address>>2] : 32'bz;
	always @(posedge clk)
		if (MemWrite)
			MEM[Address>>2] = WriteData;
endmodule