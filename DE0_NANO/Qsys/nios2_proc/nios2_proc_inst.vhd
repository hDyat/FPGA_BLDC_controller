	component nios2_proc is
		port (
			adc_data_external_connection_export  : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			clk_clk                              : in  std_logic                     := 'X';             -- clk
			lcd_external_connection_export       : out std_logic_vector(10 downto 0);                    -- export
			pwm_out_external_connection_export   : out std_logic_vector(7 downto 0);                     -- export
			reset_reset_n                        : in  std_logic                     := 'X';             -- reset_n
			speed_ref_external_connection_export : in  std_logic_vector(9 downto 0)  := (others => 'X')  -- export
		);
	end component nios2_proc;

	u0 : component nios2_proc
		port map (
			adc_data_external_connection_export  => CONNECTED_TO_adc_data_external_connection_export,  --  adc_data_external_connection.export
			clk_clk                              => CONNECTED_TO_clk_clk,                              --                           clk.clk
			lcd_external_connection_export       => CONNECTED_TO_lcd_external_connection_export,       --       lcd_external_connection.export
			pwm_out_external_connection_export   => CONNECTED_TO_pwm_out_external_connection_export,   --   pwm_out_external_connection.export
			reset_reset_n                        => CONNECTED_TO_reset_reset_n,                        --                         reset.reset_n
			speed_ref_external_connection_export => CONNECTED_TO_speed_ref_external_connection_export  -- speed_ref_external_connection.export
		);

