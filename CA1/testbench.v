module testbench();
	reg clk;
	reg rst;
	reg start;
	reg finish;
	reg [9:0] AIN;
	reg [4:0] DIN;
	wire [5:0] QUO, REM;
	wire divby0, overflow;
	
	Divider my_ic(.clk(clk), .rst(rst), .start(start), .finish(finish), .AIN(AIN),
		.DIN(DIN), .QUO(QUO), .REM(REM), .divby0(divby0), .overflow(overflow));

	always #5 clk <= ~clk;
	initial begin
		{clk, rst, start, finish} = 0;
		#10 rst = 1;
		#10 rst = 0;
		repeat (10) begin		
		#500 finish = 1;
		#10 {AIN, DIN} = $random;
		finish = 0;
		#10 start = 1;
		#10 start = 0;
		end
		
		#500 $stop;
	end
endmodule