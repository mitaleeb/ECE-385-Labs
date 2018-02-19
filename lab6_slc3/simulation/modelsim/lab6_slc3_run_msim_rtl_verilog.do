transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/HexDriver.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/tristate.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/test_memory.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/SLC3_2.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/Mem2IO.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/ISDU.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/datapath.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/slc3.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/memory_contents.sv}
vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/lab6_toplevel.sv}

vlog -sv -work work +incdir+D:/Users/Dean/Documents/ECE\ 385/lab6_slc3 {D:/Users/Dean/Documents/ECE 385/lab6_slc3/test_memory.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test_memory

add wave *
view structure
view signals
run -all
