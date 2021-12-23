module simple_filter 
#(parameter DATA_WIDTH = 10, parameter ADDRESS_WIDTH = 10)
(
	clock,
	rst,
	datain,
	data_filter
);
	
	input clock;
	input rst;
	input [DATA_WIDTH-1:0] datain;
	output reg [DATA_WIDTH-1:0] data_filter;
	
	wire [ADDRESS_WIDTH-1:0] address;
	
	wire clock_1khz;
	//instantiate clock divider
	clk_div #(.n(12)) U0 (
		.clk_sys(clock),
		.reset(rst),
		.clock_div(clock_1khz)
	);	
	
	//instantiate counter module
	counter1 # (.N(ADDRESS_WIDTH)) U1 (
		.clock(clock_1khz),
		.rst(rst),
		.count(address)
	);
	
	//instantiate ram module
//	ram32x10 U2 (
//		.clock(clock_1khz),
//		.data(datain),
//		.address(address),
//		.wren(1'b1),
//		.q(dataout)
//	);
	
	reg [9:0] Q;
	always @ (posedge clock_1khz, posedge rst)
		if (rst)
			Q <= 0;
		else
			Q <= datain;
	
	integer i;
	reg [DATA_WIDTH-1:0] min;	
	
	wire load_flag = (address == 10'h0);
	wire comp = (Q < min);
	
	always @ (posedge clock_1khz)
	begin
		if (load_flag)
			min <= Q;
		for(i = 0; i < 1024; i = i+1)
		begin
			if(comp)
				min <= Q;
		end
	end
	
	wire load_new_data = (address == 'h3ff);
	
	always @ (posedge clock_1khz)
		if(load_new_data)
			data_filter <= min;
		else
			data_filter <= data_filter;
			
	initial
	begin
		data_filter <= 0;
		min <= 0;
	end
	//assign data_filter = min;
//	wire data_filter_comp = (min > (data_filter + 100));
//	
//	always @ (posedge clock_1khz)
//	begin
//		if (data_filter_comp)
//			data_filter <= min;
//	end
	
	
endmodule

module counter1
#(parameter N = 6)
(
	clock,
	rst,
	count
);
	input clock;
	input rst;
	output reg [N-1:0] count;
	
	always @ (posedge clock, posedge rst)
		if (rst)
			count <= 10'h0;
		else
			count <= count + 10'h1;
	
endmodule
