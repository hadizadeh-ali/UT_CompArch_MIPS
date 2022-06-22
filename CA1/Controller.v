module Controller (clk, rst, start, Qp1, Qsl, Qrd, Asl, Ard, Drd, Crst, Cp1, Anew, Cn, ovf, neg, zer, divby0, overflow, finish);
	input clk;
	// control inputs
	input rst, start, Cn, ovf, neg, zer, finish;
	output reg Qp1, Qsl, Qrd, Asl, Ard, Drd, Crst, Cp1, Anew, divby0, overflow;
	reg [3:0] pstate, nstate;
	parameter [3:0]	IDLE 	= 0,
			READ 	= 1,
			CHECK	= 2,
			DB0	= 3,
			OVF	= 4,
			SHIFT	= 5,
			NEG	= 6,
			SUB	= 7,
			COUNT	= 8;
	// nstate
	always @(pstate, start, zer, ovf, neg, Cn, finish) begin
		case(pstate)
			IDLE:	nstate = start ? READ : IDLE;
			READ:	nstate = CHECK;
			CHECK:	nstate = zer ? DB0 : ovf ? OVF : NEG;
			DB0:	nstate = finish ? IDLE : DB0;
			OVF:	nstate = finish ? IDLE : OVF;
			SHIFT:	nstate = NEG;
			NEG:	nstate = neg ? COUNT : SUB;
			SUB:	nstate = COUNT;
			COUNT:	nstate = Cn ? IDLE : SHIFT;
		endcase
	end
	// control outputs
	always @(pstate) begin
		//nstate = 0;
		{Drd, Qrd, Ard, Anew, Crst, divby0, overflow, Asl, Qsl, Ard, Anew, Qp1, Cp1} = 0;
		case(pstate)
			IDLE:  ;
			READ:  {Drd, Qrd, Ard, Anew, Crst}=5'b11111;
			CHECK: ;
			DB0:   divby0 = 1'b1;
			OVF:   overflow = 1'b1;
			SHIFT: {Asl, Qsl} = 2'b11;
			NEG:   ;
			SUB:   {Ard, Anew, Qp1} = 3'b101;
			COUNT: Cp1 = 1'b1;
		endcase
	end
	// pstate
	always @(posedge clk, posedge rst) begin
		if(rst)
			pstate <= IDLE;
		else
			pstate <= nstate;
	end
endmodule