vlib work
vlog DataBusBuffer.v ControlLogic.v Encoder.v IRR.v PriorityResolver.v ReadWriteLogic.v InterruptController.v InterruptController_tb.v
vsim -voptargs=+acc work.InterruptController_tb
add wave /InterruptController_tb/INTA
add wave /InterruptController_tb/INT
add wave /InterruptController_tb/InterruptController/irr
add wave /InterruptController_tb/InterruptController/isr
add wave /InterruptController_tb/InterruptController/number_of_ack
add wave /InterruptController_tb/InterruptController/ControlLogic/vector_address
add wave /InterruptController_tb/A0
add wave /InterruptController_tb/RD
add wave /InterruptController_tb/WR
add wave /InterruptController_tb/InterruptController/DATABUS
add wave /InterruptController_tb/InterruptController/direction
add wave /InterruptController_tb/InterruptController/ControlLogic/currentstate
add wave /InterruptController_tb/InterruptController/ControlLogic/nextstate
add wave /InterruptController_tb/InterruptController/ControlLogic/icw1
add wave /InterruptController_tb/InterruptController/ControlLogic/icw2
add wave /InterruptController_tb/InterruptController/ControlLogic/icw3
add wave /InterruptController_tb/InterruptController/ControlLogic/icw4
run -all