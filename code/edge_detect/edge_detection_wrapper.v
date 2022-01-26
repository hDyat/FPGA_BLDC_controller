module edge_detection_wrapper (
	clock,
	reset,
	hall_a,
	hall_b,
	hall_c,
	hall_f_a,
	hall_f_b,
	hall_f_c
);
	
	input clock;
	input reset;
	input hall_a;
	input hall_b;
	input hall_c;
	
	output hall_f_a;
	output hall_f_b;
	output hall_f_c;
	
	//hall a edge detection
	edge_detection HA (
		.clock(clock),
		.reset(reset),
		.data(hall_a),
		.z(hall_f_a)
	);
	
	//hall b edge detection
	edge_detection HB (
		.clock(clock),
		.reset(reset),
		.data(hall_b),
		.z(hall_f_b)
	);
	
	//hall a edge detection
	edge_detection HC (
		.clock(clock),
		.reset(reset),
		.data(hall_c),
		.z(hall_f_c)
	);

endmodule