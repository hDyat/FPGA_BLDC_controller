# This project is about BLDC motor controller using FPGA. 
The picture below shows the block diagram of the system design, the outline of the system consists of hardware (three-phase inverter) and FPGA (modules written in Verilog HDL) 

<img src="https://user-images.githubusercontent.com/49807950/174469247-d4324b46-c33f-416a-863b-4184044c8d0d.png" width=500 height=250>

Modules inside fpga are connected as illustrated in the picture below

<img src = "https://user-images.githubusercontent.com/49807950/207262613-81f2b3a9-3ecc-4674-a009-87fd168731ec.png" width=400 height = 400>

## trapezoid control
The main part of this controller is trapezoid control algorithm or six-step commutation algorithm which is inside the "commutation hall effect sensor module". this module is written in Verilog HDL based on the table and state machine below:

<img src="https://user-images.githubusercontent.com/49807950/174472223-2e3d6be1-c13d-49de-8684-d1b377dc2511.png" width=250 height=200> <img src="https://user-images.githubusercontent.com/49807950/174472233-30998467-eafc-4b12-9ed8-58a2ccc806b3.png" width=250 height=200> <img src="https://user-images.githubusercontent.com/49807950/174472426-866393a9-b109-4731-8f35-352881ec329c.png" width=200 height=200>


## speed calculator
Another feature of this controller is speed calculation modules that provide information about the speed rotation of the BLDC motor in rpm. the speed data are acquired from hall effect sensor signal, because this signal sometimes produces noise, hence I also designed digital filter along with analog filter (low pass filter) to reduce the noise.

## Motor Driver (3-phase Inverter + FPGA Board)
<img src="https://user-images.githubusercontent.com/49807950/207264480-1258c45a-fc92-4426-aca2-d14f0269f39f.jpeg" width = 500 height = 300>



