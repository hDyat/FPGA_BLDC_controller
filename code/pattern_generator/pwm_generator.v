`timescale 1ns/1ps

module pwm_generator(clk, rst, enable, potensio_value, PWM);
	parameter n = 10;
	input clk, rst, enable;
	input [n-1:0] potensio_value;
	output wire PWM;
	reg PWM_out;
	
	wire [n-1:0] counter_out;
	
	always @ (posedge clk)
		if(potensio_value > counter_out)
			PWM_out <= 1'b1;
		else PWM_out <= 1'b0;
	assign PWM = enable ? PWM_out : 1'b0;
	
	//instantiate counter module
	counter_10bits #(.k(n)) U0 (
		.clk(clk), 
		.rst(rst), 
		.count_out(counter_out)
	);
	
endmodule

module counter_10bits(clk, rst, count_out);
	parameter k = 10;
	input clk, rst;
	output reg [k-1:0] count_out; 
	
	always @ (posedge clk, posedge rst)
	begin
		if(rst)
			count_out <= 0;
		else
			count_out <= count_out + {{(k-1){1'b0}}, 1'b1};
	end 
endmodule 