module speed_computation(clk_sys, Hall_sensor, rst, RPM_out);
	parameter n=13;						//13 bits is enough to represent counter up to 5000 RPM
	parameter m=26;
	parameter k=7;							//7 bits is enough to represent counter up to 5000/60 radian per second
	input clk_sys;							//this clock using 50MHz of FPGA clock system
	input Hall_sensor;					//this Hall sensor acted as clock;
	input rst;
	output [n-1:0] RPM_out;
	
	reg [k-1:0] RPS_out = 7'b0; 
	wire rst_to_zero;
	wire [k-1:0] rotation_per_second;
	wire [m-1:0] sys_count;
	wire en_mechanical_cycle;
	
	//instantiate electrical_cycle_counter_upto_16 module
	electrical_cycle_counter_upto_16 U0 (
		.clk(Hall_sensor), /* .rst(rst), */ 
		.en_mechanical_cycle(en_mechanical_cycle)
	);
	
	//instantiate mechanical_cycle_counter module
	mechanical_cycle_counter U1 (
		.clk(Hall_sensor),
		.rst_to_zero(rst_to_zero), 
		.enable(en_mechanical_cycle),
		.mec_cycle_count(rotation_per_second)
	);
	
	//instantiate general_counter module
	general_counter U2 (
		.clk_sys(clk_sys), 
		.rst(rst), 
		.sys_counter_up(sys_count)
	);
	
	assign rst_to_zero = (sys_count == 26'h2faf080) ? 1'b1 : 1'b0;
	
	always @ (posedge clk_sys)
	begin
		if(sys_count == 26'h2faf07f) RPS_out <= rotation_per_second;
		else RPS_out <= RPS_out;
	end
	
	//assign RPS_out = (sys_count < 26'h2faf080) ? RPS_out : rotation_per_second; 
	assign RPM_out = RPS_out * 6'h3c;		//RPM_out = RPS times 60
	
endmodule

module electrical_cycle_counter_upto_16 (clk, /* rst, */ en_mechanical_cycle);
	input clk;										//consider HallA/HallB/HallC as clock for this module
	/* input rst; */
	output wire en_mechanical_cycle;
	
	reg [4:0] counter_up = 0;
	
	always @(posedge clk)
	begin
		// if(rst)
			// counter_up <= 5'b00000;
		// else 
			if(counter_up == 5'b10000) counter_up <= 5'b00000;
			else counter_up <= counter_up + 5'b00001;
	end 
	
	assign en_mechanical_cycle = (counter_up == 5'b10000) ? 1'b1 : 1'b0;
	
endmodule

module mechanical_cycle_counter(clk,  rst_to_zero, enable, mec_cycle_count);
	parameter n = 7;							
	input clk;									// this is using HallA/HallB/HallC as clock
	input rst_to_zero, enable;
	output reg [n-1:0] mec_cycle_count = 0; 

	
	always @(posedge clk or posedge rst_to_zero)
	begin
		if(rst_to_zero)
			mec_cycle_count <= 7'b0;
		else 
			if(enable) mec_cycle_count <= mec_cycle_count + {{(n-1){1'b0}},1'b1};
			else mec_cycle_count <= mec_cycle_count;
	end 
endmodule

module general_counter(clk_sys, rst, sys_counter_up);
	parameter n = 26;
	input clk_sys;					//this clock using hall effect
	input rst;
	output reg [n-1:0] sys_counter_up;
	reg [n-1:0] counter_ref;
	
	
	always @(posedge clk_sys)
	begin
		if(rst)
			sys_counter_up <= 26'b0;
		else 
			if(sys_counter_up == 26'h2faf080) sys_counter_up <= 2'b0;
			else sys_counter_up <= sys_counter_up + {{(n-1){1'b0}}, 1'b1};
	end
endmodule
