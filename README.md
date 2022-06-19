# This project is about BLDC motor controller using FPGA. 
the picrute below shows the block diagram of the system design, the outline of the system consists of hardware (three-phase inverter) and FPGA (modules written in Verilog HDL) 

<img src="https://user-images.githubusercontent.com/49807950/174469247-d4324b46-c33f-416a-863b-4184044c8d0d.png" width=600 height=300>

## trapezpod control
The main part of this controller is trapezoid control or six-step commutation which is inside the "commutation hall effect sensor module". this module is written in verilog HDL based on the table and state machine below:

<img src="https://user-images.githubusercontent.com/49807950/174472223-2e3d6be1-c13d-49de-8684-d1b377dc2511.png" width=350 height=300> <img src="https://user-images.githubusercontent.com/49807950/174472233-30998467-eafc-4b12-9ed8-58a2ccc806b3.png" width=350 height=300> <img src="https://user-images.githubusercontent.com/49807950/174472426-866393a9-b109-4731-8f35-352881ec329c.png" width=300 height=300>


## speed calculator
 another feature of this controller is speed calculation modules that provide information about the speed of rotation of bldc motor in rpm.
