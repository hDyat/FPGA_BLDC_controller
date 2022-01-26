
module nios2_proc (
	adc_data_external_connection_export,
	clk_clk,
	lcd_external_connection_export,
	pwm_out_external_connection_export,
	reset_reset_n,
	speed_ref_external_connection_export);	

	input	[7:0]	adc_data_external_connection_export;
	input		clk_clk;
	output	[10:0]	lcd_external_connection_export;
	output	[7:0]	pwm_out_external_connection_export;
	input		reset_reset_n;
	input	[9:0]	speed_ref_external_connection_export;
endmodule
