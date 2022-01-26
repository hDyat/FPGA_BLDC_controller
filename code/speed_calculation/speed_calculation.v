module speed_calculation 
#(parameter MAX_VALUE = 49_999_999)
(
	clk,
	rst,
	hall_sensor,
	revolution
);
	
	input clk;
	input rst;
	input hall_sensor;
	
	output [7:0] revolution;
	
	//wire enable;
	
	//assign enable = (HA & ~LA & ~HB & LB & ~LC);
	
	reg [25:0] count;
	wire max_count = (count == MAX_VALUE); //max_count = 49,999,999
	always @ (posedge clk)
		if(rst)
			count <= 26'h0;
		else if(max_count)
			count <= 26'h0;
		else
			count <= count + 26'h1;
	
	//counter mechanical cycles
	reg [7:0] mec_cycles = 8'h0;
	wire min_count = (count == 26'h0);
	always @ (posedge hall_sensor, posedge min_count)
		if(min_count)
			mec_cycles <= 8'h0;
		else
			mec_cycles <= mec_cycles + 8'h1;
	
	reg [7:0] D;
	always @ (posedge clk)
		if(rst)
			D <= 8'h0;
		else if(max_count)
			D <= mec_cycles;
			
	assign revolution = D;
endmodule

