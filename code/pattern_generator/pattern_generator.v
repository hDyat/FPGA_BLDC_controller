module pattern_generator 
	(
		HallA, 
		HallB, 
		HallC, 
		HA, 
		HB, 
		HC, 
		LA, 
		LB, 
		LC
	);
	
	input HallA, HallB, HallC;
	output HA, HB, HC, LA, LB, LC;
	
	parameter A = 3'b101; 
	parameter B = 3'b100; 
	parameter C = 3'b110; 
	parameter D = 3'b010; 
	parameter E = 3'b011; 
	parameter F = 3'b001;
	
	reg [2:0] state;
	
	always @ (HallA, HallB, HallC)
		state <= {HallA, HallB, HallC};
	
	assign HA = (state == A) || (state == B);	
	assign HB = (state == C) || (state == D);
	assign HC = (state == E) || (state == F);
	assign LA = (state == D) || (state == E);
	assign LB = (state == A) || (state == F);
	assign LC = (state == B) || (state == C);
//	
//	always @ (state)
//	begin
//		case(state)
//		A:	begin 
//			HA = 1'b1;
//			HB	= 1'b0;
//			HC = 1'b0;
//			LA = 1'b0;
//			LB = 1'b1;
//			LC = 1'b0;
//			end
//		B:	begin
//			HA = 1'b1;
//			HB = 1'b0;
//			HC = 1'b0;
//			LA = 1'b0;
//			LB = 1'b0;
//			LC = 1'b1;
//			end
//		C: begin
//			HA = 1'b0;
//			HB = 1'b1;
//			HC = 1'b0;
//			LA = 1'b0;
//			LB = 1'b0;
//			LC = 1'b1;
//			end
//		D: begin
//			HA = 1'b0;
//			HB = 1'b1;
//			HC = 1'b0;
//			LA = 1'b1;
//			LB = 1'b0;
//			LC = 1'b0;
//			end
//		E: begin
//			HA = 1'b0;
//			HB = 1'b0;
//			HC = 1'b1;
//			LA = 1'b1;
//			LB = 1'b0;
//			LC = 1'b0;
//			end
//		F:	begin
//			HA = 1'b0;
//			HB = 1'b0;
//			HC = 1'b1;
//			LA = 1'b0;
//			LB = 1'b1;
//			LC = 1'b0;
//			end
//		default: begin
//			HA = 1'bx;
//			HB = 1'bx;
//			HC	= 1'bx;
//			LA = 1'bx;
//			LB = 1'bx;
//			LC = 1'bx;
//			end
//		endcase
//	end

endmodule
