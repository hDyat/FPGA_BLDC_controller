module counter 
    (
        clock,
        reset,
        reset_to_zero,
        count
    );
		
	parameter n = 11;
    input        clock;
    input        reset;
    input        reset_to_zero;
    output reg [n-1:0] count;

    //reg    [8:0] count;

    localparam max_count = 435;

    always @ (posedge clock)
	 begin
        if (reset)
            count <= 11'b0;
        else if(reset_to_zero == 1'b1)
            count <= 11'b0;
        else if(count == (max_count - 1))
            count <= 11'b0;
        else
            count <= count + {{n-1{1'b0}}, 1'b1};
    end
  

endmodule