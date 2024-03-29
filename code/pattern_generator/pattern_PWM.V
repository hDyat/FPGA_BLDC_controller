module pattern_PWM 
	(
		clk, 
		rst, 
		potensio_value, 
		HallA, 
		HallB, 
		HallC,
		forward,
		PWM_HA, 
		PWM_HB, 
		PWM_HC, 
		PWM_LA, 
		PWM_LB, 
		PWM_LC,
		HA,
		HB, 
		HC,
		LA,
		LB,
		LC
	);
	
	parameter dwidth = 10;
	input clk; 
	input rst;
	input forward;
	input HallA; 
	input HallB; 
	input HallC;
	input [dwidth-1:0] potensio_value;
	
	output PWM_HA;
	output PWM_HB;
	output PWM_HC;
	output PWM_LA;
	output PWM_LB;
	output PWM_LC;
	output HA;
	output HB;
	output HC;
	output LA;
	output LB;
	output LC;
	
	wire clock_pwm;
	
	wire HA;
	wire HB;
	wire HC;
	wire LA;
	wire LB;
	wire LC;
	
//	clk_div#(.n(5)) div1(
//		.clk_sys(clk),
//		.reset(rst), 
//		.clock_div(clock_pwm)
//	);
	
	assign clock_pwm = clk;
	
	fw_rv_commutation U0 (
		.clock(clk),
		.reset(rst),
		.forward(forward),
		.halla(HallA),
		.hallb(HallB),
		.hallc(HallC),
		.ha(HA),
		.hb(HB),
		.hc(HC),
		.la(LA),
		.lb(LB),
		.lc(LC)
	);
	
	//instantiate PWM_generator
	pwm_generator #(.n(dwidth)) U1(
		.clk(clock_pwm), 
		.rst(rst), 
		.enable(HA), 
		.potensio_value(potensio_value), 
		.PWM(PWM_HA)
	);
	pwm_generator #(.n(dwidth)) U2(
		.clk(clock_pwm), 
		.rst(rst), 
		.enable(HB), 
		.potensio_value(potensio_value), 
		.PWM(PWM_HB)
	);
	pwm_generator #(.n(dwidth)) U3(
		.clk(clock_pwm), 
		.rst(rst), 
		.enable(HC), 
		.potensio_value(potensio_value), 
		.PWM(PWM_HC)
	);
	
	//unipolar independent pwm switching
	assign PWM_LA = LA;
	assign PWM_LB = LB;
	assign PWM_LC = LC;
	
	
	
	//bipolar independent pwm switching
//	pwm_generator #(.n(dwidth)) U4(
//		.clk(clock_pwm), 
//		.rst(rst), 
//		.enable(LA), 
//		.potensio_value(potensio_value), 
//		.PWM(PWM_LA)
//	);
//	pwm_generator #(.n(dwidth)) U5(
//		.clk(clk), 
//		.rst(rst), 
//		.enable(LB), 
//		.potensio_value(potensio_value), 
//		.PWM(PWM_LB)
//	);
//	pwm_generator #(.n(dwidth)) U6(
//		.clk(clk), 
//		.rst(rst), 
//		.enable(LC), 
//		.potensio_value(potensio_value), 
//		.PWM(PWM_LC)
//	);
	
	
	
	
	//unipolar complementary pwm switching but didn't work
	//because this method need apply dead time control
//	assign PWM_LA = (HA == 1) ? ~PWM_HA : LA;
//	assign PWM_LB = (HB == 1) ? ~PWM_HB : LB;
//	assign PWM_LC = (HC == 1) ? ~PWM_HC	: LC;
	
endmodule
