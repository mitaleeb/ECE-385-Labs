transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/four_bit_adder.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/HexDriver.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/ADD_SUB9.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/control.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/reg8.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/Synchronizers.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/lab5_multiplier.sv}

vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab5_multiplier {D:/Users/Dean/Documents/ECE 385/lab5_multiplier/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
