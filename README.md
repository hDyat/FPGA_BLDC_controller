# This project is about bldc motor controller using FPGA. 
the picrute below shows the block diagram of the system design, the outline of the system consists of hardware (three-phase inverter) and fpga (modules written in Verilog HDL) 

<img src="https://user-images.githubusercontent.com/49807950/174469247-d4324b46-c33f-416a-863b-4184044c8d0d.png" width=600 height=300>

The main part of this controller is trapezoid control or six-step commutation which is inside the "commutation hall effect sensor module". this module is written in verilog HDL based on the table and state machine below:

