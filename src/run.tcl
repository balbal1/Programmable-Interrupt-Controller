vlib work
vlog InterruptController_tb.v InterruptController.v ControlLogic.v PriorityResolver.v IRR.v DataBusBuffer.v ReadWriteLogic.v Encoder.v
vsim -voptargs=+acc work.InterruptController_tb
add wave /InterruptController_tb/INTA
add wave /InterruptController_tb/INT
add wave /InterruptController_tb/InterruptController/irr
add wave /InterruptController_tb/InterruptController/isr
add wave /InterruptController_tb/InterruptController/number_of_ack
add wave /InterruptController_tb/A0
add wave /InterruptController_tb/RD
add wave /InterruptController_tb/WR
add wave /InterruptController_tb/CS
add wave /InterruptController_tb/InterruptController/direction
add wave /InterruptController_tb/InterruptController/vector_address
add wave /InterruptController_tb/DATABUS
add wave /InterruptController_tb/InterruptController/ControlLogic/currentstate
add wave /InterruptController_tb/InterruptController/ControlLogic/nextstate
add wave /InterruptController_tb/InterruptController/ControlLogic/icw1
add wave /InterruptController_tb/InterruptController/ControlLogic/icw2
add wave /InterruptController_tb/InterruptController/ControlLogic/icw3
add wave /InterruptController_tb/InterruptController/ControlLogic/icw4
add wave /InterruptController_tb/InterruptController/ControlLogic/ocw1
add wave /InterruptController_tb/InterruptController/ControlLogic/ocw2
add wave /InterruptController_tb/InterruptController/ControlLogic/ocw3
run -all