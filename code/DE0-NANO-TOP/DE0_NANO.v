module DE0_NANO (
	//////////// CLOCK //////////
	CLOCK_50,

	//////////// LED //////////
	LED,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// SDRAM //////////
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_DQM,
	DRAM_RAS_N,
	DRAM_WE_N,

	//////////// EPCS //////////
	EPCS_ASDO,
	EPCS_DATA0,
	EPCS_DCLK,
	EPCS_NCSO,

	//////////// Accelerometer and EEPROM //////////
	G_SENSOR_CS_N,
	G_SENSOR_INT,
	I2C_SCLK,
	I2C_SDAT,

	//////////// ADC //////////
	ADC_CS_N,
	ADC_SADDR,
	ADC_SCLK,
	ADC_SDAT,

	//////////// 2x13 GPIO Header //////////
	GPIO_2,
	GPIO_2_IN,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	GPIO_0,
	GPIO_0_IN,

	//////////// GPIO_0, GPIO_1 connect to GPIO Default //////////
	GPIO_1,
	GPIO_1_IN

);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;

//////////// LED //////////
output		     [7:0]		LED;

//////////// KEY //////////
input 		     [1:0]		KEY;

//////////// SW //////////
input 		     [3:0]		SW;

//////////// SDRAM //////////
output		    [12:0]		DRAM_ADDR;
output		     [1:0]		DRAM_BA;
output		          		DRAM_CAS_N;
output		          		DRAM_CKE;
output		          		DRAM_CLK;
output		          		DRAM_CS_N;
inout 		    [15:0]		DRAM_DQ;
output		     [1:0]		DRAM_DQM;
output		          		DRAM_RAS_N;
output		          		DRAM_WE_N;

//////////// EPCS //////////
output		          		EPCS_ASDO;
input 		          		EPCS_DATA0;
output		          		EPCS_DCLK;
output		          		EPCS_NCSO;

//////////// Accelerometer and EEPROM //////////
output		          		G_SENSOR_CS_N;
input 		          		G_SENSOR_INT;
output		          		I2C_SCLK;
inout 		          		I2C_SDAT;

//////////// ADC //////////
output		          		ADC_CS_N;
output		          		ADC_SADDR;
output		          		ADC_SCLK;
input 		          		ADC_SDAT;

//////////// 2x13 GPIO Header //////////
inout 		    [12:0]		GPIO_2;
input 		     [2:0]		GPIO_2_IN;

//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
inout 		    [33:0]		GPIO_0;
input 		     [1:0]		GPIO_0_IN;

//////////// GPIO_0, GPIO_1 connect to GPIO Default //////////
inout 		    [33:0]		GPIO_1;
input 		     [1:0]		GPIO_1_IN;


//=======================================================
//  REG/WIRE declarations
//=======================================================

	//internal signals
	wire clk_sys = CLOCK_50;
	wire rst = 1'b0;
	
	//hall input signals
	wire hall_a = GPIO_1[0];
	wire hall_b = GPIO_1[1];
	wire hall_c = GPIO_1[3];
	
	//output signals
	wire pwm_ha;
	wire pwm_hb;
	wire pwm_hc;
	wire pwm_la;
	wire pwm_lb;
	wire pwm_lc;
	//temporary signals
	wire ha;
	wire hb;
	wire hc;
	wire la;
	wire lb;
	wire lc;
	wire toggle;
	
	//spi signals
	wire wSPI_CLK;
	wire wSPI_CLK_n;
	wire [7:0] ADC_data;
	
	//bldc speed measurement signal
	wire [7:0] rpm;
//	wire [12:0] speed_a, speed_b, speed_c;
//	wire [2:0] hall_effect = {hall_a, hall_b, hall_c};
//	wire [12:0] speed_temp0 = (speed_a < speed_b) ? speed_a : speed_b;
//	wire [12:0] speed = (speed_temp0 < speed_c) ? speed_temp0 : speed_c;

//=======================================================
//  Structural coding
//=======================================================
	//instantiate pattern_pwm module
	pattern_PWM #(.dwidth(8)) U0 (
		.clk(clk_sys), 
		.rst(rst), 
		.potensio_value(ADC_data), 
		.HallA(hall_a), 
		.HallB(hall_b), 
		.HallC(hall_c), 
		.PWM_HA(pwm_ha),
		.PWM_HB(pwm_hb),
		.PWM_HC(pwm_hc),
		.PWM_LA(pwm_la),
		.PWM_LB(pwm_lb),
		.PWM_LC(pwm_lc),
		.HA(ha),
		.HB(hb),
		.HC(hc),
		.LA(la),
		.LB(lb),
		.LC(lc),
		.toggle(toggle),
		.rpm(rpm)
	);
	
	assign GPIO_0[13] = pwm_ha;
	assign GPIO_0[15] = pwm_la;
	assign GPIO_0[17] = pwm_hb;
	assign GPIO_0[19] = pwm_lb;
	assign GPIO_0[21] = pwm_hc;
	assign GPIO_0[23] = pwm_lc;
	
	assign LED = rpm;
	//assign GPIO_1[23:13] = rpm;
	//assign LED[0] = toggle;
	assign GPIO_1[13] = pwm_ha;
	assign GPIO_1[15] = pwm_lc;
	assign GPIO_1[17] = pwm_hb;
	assign GPIO_1[19] = pwm_la;
	assign GPIO_1[21] = pwm_hc;
	assign GPIO_1[23] = pwm_lb;
	
	SPIPLL		U1	(
		.inclk0(CLOCK_50),
		.c0(wSPI_CLK),
		.c1(wSPI_CLK_n)
	);

	ADC_CTRL		U2	(
		.iRST(KEY[0]),
		.iCLK(wSPI_CLK),
		.iCLK_n(wSPI_CLK_n),
		.iGO(KEY[1]),
		.iCH(SW[2:0]),
		.oLED(ADC_data),
						
		.oDIN(ADC_SADDR),
		.oCS_n(ADC_CS_N),
		.oSCLK(ADC_SCLK),
		.iDOUT(ADC_SDAT)
	);
	
	//assign LED = ADC_data;
	
//	top_speed_mac U3 (
//		.clock_sys(clk_sys),
//		.reset(rst),
//		.hall_effect(hall_effect),
//		.speed(speed),
//		.toggle(toggle)
//	);

//	speed_computation U3 (
//		.clk_sys(clk_sys),
//		.Hall_sensor(hall_a),
//		.rst(rst),
//		.RPM_out(speed_a)
//	);
//	
//	speed_computation U4 (
//		.clk_sys(clk_sys),
//		.Hall_sensor(hall_b),
//		.rst(rst),
//		.RPM_out(speed_b)
//	);
//	
//	speed_computation U5 (
//		.clk_sys(clk_sys),
//		.Hall_sensor(hall_c),
//		.rst(rst),
//		.RPM_out(speed_c)
//	);
	
	
	
	

endmodule
