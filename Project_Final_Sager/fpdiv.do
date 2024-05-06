# Copyright 1991-2016 Mentor Graphics Corporation
# 
# Modification by Oklahoma State University
# Use with Testbench 
# James Stine, 2008
# Go Cowboys!!!!!!
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
# WHICH IS THE PROPERTY OF MENTOR GRAPHICS CORPORATION
# OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.

# Use this run.do file to run this example.
# Either bring up ModelSim and type the following at the "ModelSim>" prompt:
#     do run.do
# or, to run from a shell, type the following at the shell prompt:
#     vsim -do fpdiv.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile source files
vlog fpdiv.sv flopenr.sv mux.sv tb_fpdiv.sv

# start and run simulation
vsim -voptargs=+acc work.stimulus

view wave

-- display input and output signals as hexidecimal values
# Diplays All Signals recursively
add wave -noupdate -divider -height 32 "rounding"
add wave -hex /stimulus/dut/G
add wave -hex /stimulus/dut/mux_final
add wave -hex /stimulus/dut/rega_out
add wave -hex /stimulus/dut/rrem
add wave -color gold -hex /stimulus/dut/clk
add wave -hex /stimulus/dut/Q_sum1
add wave -hex /stimulus/dut/QP_sum1
add wave -hex /stimulus/dut/QM_sum1
add wave -hex /stimulus/dut/Q_sum0
add wave -hex /stimulus/dut/QP_sum0
add wave -hex /stimulus/dut/QM_sum0
add wave -noupdate -divider -height 32 "Everything"
add wave -hex -r /stimulus/*



-- Set Wave Output Items 
TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ps} {75 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 200
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

-- Run the Simulation 
run -all
quit
