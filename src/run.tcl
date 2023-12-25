vlib work
vlog InterruptController_tb.v InterruptController.v IRR.v ISR.v IMR.v PriorityResolver.v ControlLogic.v DataBusBuffer.v ReadWriteLogic.v Cascade.v PriorityLevel.v
vsim -voptargs=+acc work.InterruptController_tb
add wave /InterruptController_tb/INTA
add wave /InterruptController_tb/INT_master
add wave /InterruptController_tb/InterruptController/irr
add wave /InterruptController_tb/InterruptController/isr
add wave /InterruptController_tb/InterruptController/number_of_ack
add wave /InterruptController_tb/InterruptController/reset_irr_bit
add wave /InterruptController_tb/InterruptController/higher_priority
add wave /InterruptController_tb/InterruptController/irr_highest_bit
add wave /InterruptController_tb/InterruptController/isr_highest_bit
add wave /InterruptController_tb/InterruptController/PriorityResolver/priority
add wave /InterruptController_tb/InterruptController/PriorityResolver/irr_level
add wave /InterruptController_tb/InterruptController/PriorityResolver/isr_level
add wave /InterruptController_tb/A0
add wave /InterruptController_tb/RD
add wave /InterruptController_tb/WR
add wave /InterruptController_tb/CS_master
add wave /InterruptController_tb/InterruptController/direction
add wave /InterruptController_tb/DATABUS
add wave /InterruptController_tb/InterruptController/ControlLogic/icw1
add wave /InterruptController_tb/InterruptController/ControlLogic/icw2
add wave /InterruptController_tb/InterruptController/ControlLogic/icw3
add wave /InterruptController_tb/InterruptController/ControlLogic/icw4
add wave /InterruptController_tb/InterruptController/ControlLogic/ocw1
add wave /InterruptController_tb/InterruptController/ControlLogic/ocw2
add wave /InterruptController_tb/InterruptController/ControlLogic/ocw3
run -all