module fw_rv_commutation (
	clock,
	reset,
	forward,
	halla,
	hallb,
	hallc,
	ha,
	hb,
	hc,
	la,
	lb,
	lc
);
	parameter A = 3'b000,
				 B = 3'b001,
				 C = 3'b010,
				 D = 3'b011,
				 E = 3'b100,
				 F = 3'b101;
				 
	input clock;
	input reset;
	input forward;
	input halla;
	input hallb;
	input hallc;
	
	output ha;
	output hb;
	output hc;
	output la;
	output lb;
	output lc;
	
	reg [2:0] state_D, state_Q;
	
	wire [2:0] hall_sensor;
	
	assign hall_sensor = {halla, hallb, hallc};
	
	//define the next state combinatorial circuit
	always @ (hall_sensor, forward, state_Q)
		case (state_Q)
			A: if(hall_sensor == 3'b101) state_D = A;
				else if(hall_sensor == 3'b100) state_D = B;
				else if(hall_sensor == 3'b110) state_D = C;
				else if(hall_sensor == 3'b010) state_D = D;
				else if(hall_sensor == 3'b011) state_D = E;
				else if(hall_sensor == 3'b001) state_D = F;
				else state_D = A;
			B: if(hall_sensor == 3'b101) state_D = A;
				else if(hall_sensor == 3'b100) state_D = B;
				else if(hall_sensor == 3'b110) state_D = C;
				else if(hall_sensor == 3'b010) state_D = D;
				else if(hall_sensor == 3'b011) state_D = E;
				else if(hall_sensor == 3'b001) state_D = F;
				else state_D = B;
			C: if(hall_sensor == 3'b101) state_D = A;
				else if(hall_sensor == 3'b100) state_D = B;
				else if(hall_sensor == 3'b110) state_D = C;
				else if(hall_sensor == 3'b010) state_D = D;
				else if(hall_sensor == 3'b011) state_D = E;
				else if(hall_sensor == 3'b001) state_D = F;
				else state_D = C;
			D: if(hall_sensor == 3'b101) state_D = A;
				else if(hall_sensor == 3'b100) state_D = B;
				else if(hall_sensor == 3'b110) state_D = C;
				else if(hall_sensor == 3'b010) state_D = D;
				else if(hall_sensor == 3'b011) state_D = E;
				else if(hall_sensor == 3'b001) state_D = F;
				else state_D = D;
			E: if(hall_sensor == 3'b101) state_D = A;
				else if(hall_sensor == 3'b100) state_D = B;
				else if(hall_sensor == 3'b110) state_D = C;
				else if(hall_sensor == 3'b010) state_D = D;
				else if(hall_sensor == 3'b011) state_D = E;
				else if(hall_sensor == 3'b001) state_D = F;
				else state_D = E;
			F: if(hall_sensor == 3'b101) state_D = A;
				else if(hall_sensor == 3'b100) state_D = B;
				else if(hall_sensor == 3'b110) state_D = C;
				else if(hall_sensor == 3'b010) state_D = D;
				else if(hall_sensor == 3'b011) state_D = E;
				else if(hall_sensor == 3'b001) state_D = F;
				else state_D = F;
			default:	;
		endcase
	
	
	//define the sequential block
	always @ (posedge clock)
	begin
		if (reset)
			state_Q <= A;
		else
			state_Q <= state_D;
	end
	
	//define output
	assign ha = (forward == 1'b1) ? ((state_Q == D) || (state_Q == E)) : ((state_Q == A) || (state_Q == B));	
	assign hb = (forward == 1'b1) ? ((state_Q == A) || (state_Q == F)) : ((state_Q == C) || (state_Q == D));
	assign hc = (forward == 1'b1) ? ((state_Q == B) || (state_Q == C)) : ((state_Q == E) || (state_Q == F));
	assign la = (forward == 1'b1) ? ((state_Q == A) || (state_Q == B)) : ((state_Q == D) || (state_Q == E));
	assign lb = (forward == 1'b1) ? ((state_Q == C) || (state_Q == D)) : ((state_Q == A) || (state_Q == F));
	assign lc = (forward == 1'b1) ? ((state_Q == E) || (state_Q == F)) : ((state_Q == B) || (state_Q == C));
	
endmodule
