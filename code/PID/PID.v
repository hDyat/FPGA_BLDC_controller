module PID (Clock, Reset, e_in, u_out);
	parameter n = 16;
	
	input Clock, Reset;
	input [n-1:0] e_in;
	output [n-1:0] u_out;
	
	parameter k1 = 107;
	parameter k2 = 104;
	parameter k3 = 2;
	
	reg [n-1:0] u_prev;
	reg [n-1:0] e_prev[1:2];
	
	assign u_out = u_prev + k1*e_in - k2*e_prev[1] + k3*e_prev[2];
	
	always @ (posedge Clock)
	begin
		if (Reset) begin
			u_prev <= 0;
			e_prev[1] <= 0;
			e_prev[2] <= 0;
		end 
		else begin
			e_prev[2] <= e_prev[1];
			e_prev[1] <= e_in;
			u_prev <= u_out;
		end 
	end
	
endmodule