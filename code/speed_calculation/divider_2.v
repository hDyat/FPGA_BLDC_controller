module divider_2 (
	clock,
	reset,
	datain,
	dataout
);

	input clock;
	input reset;
	input [10:0] datain;
	output [9:0] dataout;
	
	reg [10:0] Q;
	
	integer i;
	always @ (posedge clock)
		if(reset)
			Q <= 10'b0;
		else
		begin
			for(i = 0; i < 10; i = i + 1)
				Q[i] <= datain[i+1];
			Q[10] <= 1'b0;
		end
	
	assign dataout = Q[9:0];
endmodule 