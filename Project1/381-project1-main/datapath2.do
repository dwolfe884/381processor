vcom -reportprogress 300 -work work /home/djwolfe/cpre381/Lab2/Lab2/tb_datapath2.vhd
vsim -voptargs="+acc" tb_datapath2
mem load -infile dmem.hex -format hex /tb_datapath2/DUT/ram/ram
add wave -position insertpoint sim:/tb_datapath2/*
run 2500
