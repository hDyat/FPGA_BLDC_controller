module speed_measurement 
    (
        clock,
        reset,
        hall_effect,
        mac_out
    );

    input       clock;
    input       reset;
    input [2:0] hall_effect;
    output reg  mac_out;

    parameter   A = 3'b101, B = 3'b100, C = 3'b110,
                D = 3'b010, E = 3'b011, F = 3'b001;

    reg [2:0]   Tstep_Q, Tstep_D; 

    //Define the next state and output combinational circuits
    always @ (Tstep_Q, hall_effect)
    begin
        mac_out = 1'b0;
        case(Tstep_Q)
            A:  if(hall_effect != 3'b101)
                begin
                    Tstep_D = hall_effect;
                    mac_out = 1'b1;
                end 
                else
                begin
                    Tstep_D = A;
                    mac_out = 1'b0;
                end                 
            B:  if(hall_effect != 3'b100) 
                begin
                    Tstep_D = hall_effect;
                    mac_out = 1'b1;    
                end   
                else
                begin
                    Tstep_D = B;
                    mac_out = 1'b0;
                end              
            C:  if(hall_effect != 3'b110) 
                begin
                    Tstep_D = hall_effect;
                    mac_out = 1'b1;
                end           
                else
                begin
                    Tstep_D = C;
                    mac_out = 1'b0;
                end      
            D:  if(hall_effect != 3'b010)
                begin
                    Tstep_D = hall_effect;
                    mac_out = 1'b1;
                end               
                else
                begin
                    Tstep_D = D;
                    mac_out = 1'b0;
                end
            E:  if(hall_effect != 3'b011) 
                begin
                    Tstep_D = hall_effect;
                    mac_out = 1'b1;
                end 
                else
                begin
                    Tstep_D = E;
                    mac_out = 1'b0;
                end
            F:  if(hall_effect != 3'b001)
                begin
                    Tstep_D = hall_effect;
                    mac_out = 1'b1;
                end
                else
                begin
                    Tstep_D = F;
                    mac_out = 1'b0;
                end
            default: 
                begin
                    Tstep_D = 3'bx;
                    mac_out = 1'bx;
                end
        endcase
    end

    //Define the sequential block
    always @ (posedge clock)
        if (reset) 
            Tstep_Q <= A;
        else
            Tstep_Q <= Tstep_D; 

endmodule