vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/lib_cdc_v1_0_3
vlib questa_lib/msim/proc_sys_reset_v5_0_15
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap lib_cdc_v1_0_3 questa_lib/msim/lib_cdc_v1_0_3
vmap proc_sys_reset_v5_0_15 questa_lib/msim/proc_sys_reset_v5_0_15
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm -64 -incr -mfcu  -sv \
"/home/ciaran-mcdj/Documents/XilinxSoftware/Vivado/2024.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93  \
"/home/ciaran-mcdj/Documents/XilinxSoftware/Vivado/2024.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work lib_cdc_v1_0_3 -64 -93  \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_15 -64 -93  \
"../../../ipstatic/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../../lab-6.gen/sources_1/ip/proc_sys_reset_0/sim/proc_sys_reset_0.vhd" \


vlog -work xil_defaultlib \
"glbl.v"

