module clk_div
	(
		clk_sys,
		reset,
		clock_div
	);
	
	parameter n = 20;
	
	input clk_sys, reset;
	output clock_div;
	
	reg[n-1:0] clock_cnt;
	wire clock_div;
	
	always @(posedge clk_sys or posedge reset)
	begin
		if(reset)
			clock_cnt <= 0;
		else
			clock_cnt <= clock_cnt + {{(n-1){1'b0}}, 1'b1};
	end
	
	assign clock_div = clock_cnt[n-1];
	
endmodule 