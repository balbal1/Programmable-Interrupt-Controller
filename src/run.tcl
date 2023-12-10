vlib work
vlog buffer.v control_logic.v encoder.v IRR.v priorityresolver.v read_write.v topmodule.v topmodule_tb.v
vsim -voptargs=+acc work.topmodule_tb
add wave /topmodule_tb/INTA
add wave /topmodule_tb/INT
add wave /topmodule_tb/top/IRR
add wave /topmodule_tb/top/ISR
add wave /topmodule_tb/top/priority/INTACOUNT
add wave /topmodule_tb/top/control/numberOfAck
add wave /topmodule_tb/top/control/vector_address
add wave /topmodule_tb/A0
add wave /topmodule_tb/RD
add wave /topmodule_tb/WR
add wave /topmodule_tb/top/dataBus
add wave /topmodule_tb/top/direction
add wave /topmodule_tb/top/control/currentstate
add wave /topmodule_tb/top/control/nextstate
add wave /topmodule_tb/top/control/icw1
add wave /topmodule_tb/top/control/icw2
add wave /topmodule_tb/top/control/icw3
add wave /topmodule_tb/top/control/icw4
run -all