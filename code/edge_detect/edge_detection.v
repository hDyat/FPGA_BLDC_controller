module edge_detection 
#(parameter n = 20, parameter div = 4)
(
	clock,
	reset,
	data,
	z
);
	
	input clock;
	input reset;
	input data;
	output z;

	localparam A = 2'b01, B = 2'b10;
	
	wire [n-1:0] Q;
	wire [1:0] w;
	wire clk_div;
	reg [1:0] state_D, state_Q; 
	
	shiftn #(.k(n)) U0 (
		.clock(clk_div), 
		.reset(reset), 
		.D(data), 
		.Q(Q)
	);
	
	clk_div #(.n(div)) U1(
		.clk_sys(clock),
		.reset(reset), 
		.clock_div(clk_div)
	);

	assign w[1] = &Q;
	assign w[0] = |Q;
	
	//Define next state
	always @ (w, state_Q)
		case (state_Q)
			A : if(w == 2'b11) state_D = B;
				 else			 state_D = A;
			B : if(w == 2'b00) state_D = A;
				 else			 state_D = B;
			default: ;
		endcase
		
	
	//Define the sequential block
	always @ (posedge clk_div)
		if(reset)
			state_Q <= A;
		else
			state_Q <= state_D;
	
	//define output
	assign z = (state_Q == B) ? 1'b1 : 1'b0;

endmodule



module shiftn 
#(parameter k = 4)
(
	clock,
	reset,
	D,
	Q
);

	input clock;
	input reset;
	input D;
	output reg [k-1:0] Q;
	
	integer i;
	always @ (posedge clock)
	begin
		if(reset)
			Q <= 0;
		else
		begin
			for(i = 0; i < k - 1; i = i + 1)
				Q[i] <= Q[i+1];
			Q[k-1] <= D;
		end
	end
	
endmodule


