transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xpm
vlib activehdl/lib_cdc_v1_0_3
vlib activehdl/proc_sys_reset_v5_0_15
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap lib_cdc_v1_0_3 activehdl/lib_cdc_v1_0_3
vmap proc_sys_reset_v5_0_15 activehdl/proc_sys_reset_v5_0_15
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 -l xpm -l lib_cdc_v1_0_3 -l proc_sys_reset_v5_0_15 -l xil_defaultlib \
"/home/ciaran-mcdj/Documents/XilinxSoftware/Vivado/2024.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -  \
"/home/ciaran-mcdj/Documents/XilinxSoftware/Vivado/2024.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work lib_cdc_v1_0_3 -  \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_15 -  \
"../../../ipstatic/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -  \
"../../../../lab-6.gen/sources_1/ip/proc_sys_reset_0/sim/proc_sys_reset_0.vhd" \


vlog -work xil_defaultlib \
"glbl.v"

