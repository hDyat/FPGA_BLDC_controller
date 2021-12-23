module D_ff 
    (
        clock,
		reset,
        enable,
        D,
        Q
    );

    parameter n = 4;

    input           clock;
    input           reset;
    input           enable;
    input [n-1:0]   D;
    output [n-1:0]  Q;

    reg [n-1:0]     Q;

    always @ (posedge clock)
        if (reset)
            Q <= 4'b0000;
        else if(enable)
            Q <= D;

endmodule