vlib work
vlog buffer.v control_logic.v encoder.v IRR.v priorityresolver.v read_write.v topmodule.v topmodule_tb.v
vsim -voptargs=+acc work.topmodule_tb
add wave *
run -all