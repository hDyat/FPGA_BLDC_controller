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
	
	//spi signals
	wire wSPI_CLK;
	wire wSPI_CLK_n;
	wire [7:0] ADC_data;
	
	//LCD signals
	wire [7:0] LCD_DATA;
	wire		  LCD_D_cn;		//RS
	wire		  LCD_WEn;		//RW
	wire		  LCD_CSn;		//Enable
	
	//bldc speed measurement signal
	wire [9:0] rpm;
	
	//nios input data;
	wire [7:0] pwm;

	//filtered hall sensor
	wire hall_f_a;
	wire hall_f_b;
	wire hall_f_c;

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
		.forward(SW[0]),
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
		.LC(lc)
	);
	
	assign GPIO_0[12] = pwm_ha;
	assign GPIO_0[14] = pwm_la;
	assign GPIO_0[16] = pwm_hb;
	assign GPIO_0[18] = pwm_lb;
	assign GPIO_0[20] = pwm_hc;
	assign GPIO_0[22] = pwm_lc;
	
	assign LED = ADC_data;
	
	assign GPIO_1[13] = pwm_ha;
	assign GPIO_1[15] = pwm_lc;
	assign GPIO_1[17] = pwm_hb;
	assign GPIO_1[19] = pwm_la;
	assign GPIO_1[21] = pwm_hc;
	assign GPIO_1[23] = pwm_lb;
	
	assign GPIO_1[18] = hall_a;
	assign GPIO_1[20] = hall_b;
	assign GPIO_1[22] = hall_c;
	
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
		.iCH(3'b000),
		.oLED(ADC_data),
						
		.oDIN(ADC_SADDR),
		.oCS_n(ADC_CS_N),
		.oSCLK(ADC_SCLK),
		.iDOUT(ADC_SDAT)
	);
	
	nios2_proc U3 (
		.clk_clk                              (CLOCK_50),
		.reset_reset_n                        (1'b1),
		.pwm_out_external_connection_export   (pwm),
		.speed_ref_external_connection_export (rpm),
		.lcd_external_connection_export       ({LCD_CSn, LCD_D_cn, LCD_WEn, LCD_DATA}),
		.adc_data_external_connection_export  (ADC_data)
	);
	
	assign GPIO_0[0] = LCD_DATA[7];
	assign GPIO_0[1] = LCD_DATA[6];
	assign GPIO_0[3] = LCD_DATA[5];
	assign GPIO_0[5] = LCD_DATA[4];
	assign GPIO_0[7] = LCD_DATA[3];
	assign GPIO_0[9] = LCD_DATA[2];
	assign GPIO_0[11] = LCD_DATA[1];
	assign GPIO_0[13] = LCD_DATA[0];
	
	assign GPIO_0[15] = LCD_CSn;
	assign GPIO_0[17] = LCD_WEn;
	assign GPIO_0[19] = LCD_D_cn;
	
	// hall filter
	edge_detection_wrapper U4 (
		.clock(CLOCK_50),
		.reset(rst),
		.hall_a(hall_a),
		.hall_b(hall_b),
		.hall_c(hall_c),
		.hall_f_a(hall_f_a),
		.hall_f_b(hall_f_b),
		.hall_f_c(hall_f_c)
	);
	
	//speed calculation of 3 hall sensors
	speed_calculation_wrapper U5 (
		.clock(CLOCK_50),
		.reset(rst),
		.hall_f_a(hall_f_a),
		.hall_f_b(hall_f_b),
		.hall_f_c(hall_f_c),
		.rpm(rpm)
	);
	
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
