vlib work
vlog -f src_files.list +cover +define+SIM -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
coverage save wrapper.ucdb -onexit
add wave /top/w_vif/*
add wave /top/s_vif/*
add wave /top/r_vif/*
run -all
#quit -sim
#vcover report wrapper.ucdb -details -annotate -all -output wrapper.txt