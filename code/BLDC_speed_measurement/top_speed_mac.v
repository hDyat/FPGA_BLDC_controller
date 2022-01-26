module top_speed_mac 
    (
        clock_sys, 
        reset,
        hall_effect,
        speed,
        toggle
    );
	 
	localparam  max_count = 435;
	parameter dwidth	= 11;

    input         clock_sys;
    input         reset;
    input  [2:0]  hall_effect;
    output        toggle;
    output [dwidth-1:0] speed;
    
    reg  toggle;
    wire [dwidth-1:0]      count;
    wire [dwidth-1:0]      commutation_tot;
    wire [dwidth-1:0]      reg_commutation;
    wire clock_1;
    wire clock_2;

    clk_div #(.n(13)) U0
        (
            .clk_sys(clock_sys),
            .reset(reset),
            .clock_div(clock_2)
        );
    
    counter #(.n(dwidth)) U1
        (
            .clock(clock_2),
            .reset(reset),
            .reset_to_zero(1'b0),
            .count(count)
        );
            
    speed_measurement U2 
        (
            .clock(clock_2),
            .reset(reset),
            .hall_effect(hall_effect),
            .mac_out(clock_1)
        );

    counter #(.n(dwidth)) U3
        (
            .clock(clock_1),
            .reset(reset),
            .reset_to_zero(toggle),
            .count(commutation_tot)
        );
    
    D_ff #(.n(dwidth)) U4
        (
            .clock(clock_2),
            .reset(reset),
            .enable(count == (max_count - 1)),
            .D(commutation_tot),
            .Q(reg_commutation)
        );

    always @ (posedge clock_2, negedge reset)
        if(!reset)
            toggle <= 1'b0;
        else if(count == (max_count - 1))
            toggle <= 1'b1;
        else
            toggle <= 1'b0;
				
	 rpm_lut U5
        (
            .D(reg_commutation),
            .Q(speed)
        );
	 
endmodule