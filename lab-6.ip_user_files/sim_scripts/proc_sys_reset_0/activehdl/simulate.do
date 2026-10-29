transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+proc_sys_reset_0  -L xpm -L lib_cdc_v1_0_3 -L proc_sys_reset_v5_0_15 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O2 xil_defaultlib.proc_sys_reset_0 xil_defaultlib.glbl

do {proc_sys_reset_0.udo}

run

endsim

quit -force
