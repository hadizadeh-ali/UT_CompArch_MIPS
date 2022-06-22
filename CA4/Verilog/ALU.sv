module ALU(A, B, F, W, z);
	input signed [31:0] A, B;
	input [2:0] F;
	output logic [31:0] W;
	output logic z;
	always @(A, B, F) begin
		case (F)
			3'b000:		W = A & B;
			3'b001:		W = A | B;
			3'b010:		W = A + B;
			3'b011: 	W = A - B;
			3'b111:		W = (A < B) ? 32'b1 : 32'b0;
			default:	W = 32'b0;
		endcase
	end
	assign z = ~|W;
endmodule