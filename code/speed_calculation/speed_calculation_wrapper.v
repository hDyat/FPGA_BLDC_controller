module speed_calculation_wrapper (
	clock,
	reset,
	hall_f_a,
	hall_f_b,
	hall_f_c,
	rpm
);
	input clock;
	input reset;
	input hall_f_a;
	input hall_f_b;
	input hall_f_c;
	
	output [9:0] rpm;
	
	wire [7:0] rev_a;
	wire [7:0] rev_b;
	wire [7:0] rev_c;
	
	wire [9:0] rpm_a;
	wire [9:0] rpm_b;
	wire [9:0] rpm_c;
	
	wire [10:0] sum1, sum0, div1;
	
	//hall a speed calculation
	speed_calculation HA (
		.clk(clock),
		.rst(reset),
		.hall_sensor(hall_f_a),
		.revolution(rev_a)
	);
	
	//hall b speed calculation
	speed_calculation HB (
		.clk(clock),
		.rst(reset),
		.hall_sensor(hall_f_b),
		.revolution(rev_b)
	);
	
	//hall c speed calculation
	speed_calculation HC (
		.clk(clock),
		.rst(reset),
		.hall_sensor(hall_f_c),
		.revolution(rev_c)
	);
	
	rpm_lut HA_l (
		.datain(rev_a),
		.dataout (rpm_a)
	);
	
	rpm_lut HB_l (
		.datain(rev_b),
		.dataout (rpm_b)
	);
	
	rpm_lut HC_1 (
		.datain (rev_c),
		.dataout (rpm_c)
	);
	
	assign sum0 = rpm_a + rpm_b;
	assign sum1 = div1 + rpm_c;
	
	divider_2 S0 (
		.clock(clock),
		.reset(reset),
		.datain(sum0),
		.dataout(div1)
	);
	
	divider_2 S1 (
		.clock(clock),
		.reset(reset),
		.datain(sum1),
		.dataout(rpm)
	);
	
endmodule
