# Copyright 1991-2007 Mentor Graphics Corporation
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
#     vsim -do cordic16_sv.do -c
# (omit the "-c" to see the GUI while running from the shell)

onbreak {resume}

# create library
if [file exists work] {
    vdel -all
}
vlib work

# compile baseline source files
#vlog dff.v ha.v fa.v rca16.v mux21.v 
# compile top source modules
#vlog mux21x16.v reg16.v xor16.v sincos.v angle.v
vlog mux.sv flop.sv sincos.sv angle.sv
# compile shifter
vlog logshift1.sv logshift2.sv logshift4.sv logshift8.sv shall.sv
# compile memory
vlog rom_cordic.sv
# compile tb and main module
vlog cordic16.sv test_cordic16.sv

# start and run simulation
vsim -voptargs=+acc work.stimulus 

view list
view wave

-- display input and output signals as hexidecimal values
# Diplays All Signals recursively
# add wave -hex -r /stimulus/*
add wave -noupdate -divider -height 32 "CORDIC"
add wave -hex /stimulus/dut/clock
add wave -hex /stimulus/dut/load
add wave -hex /stimulus/dut/endangle
add wave -hex /stimulus/dut/addr
add wave -hex /stimulus/dut/sin
add wave -hex /stimulus/dut/cos
add wave -hex /stimulus/dut/data
add wave -hex /stimulus/dut/currentangle
add wave -noupdate -divider -height 32 "Computation Units"
add wave -hex /stimulus/dut/angle1/*
add wave -hex /stimulus/dut/sincos1/*	
add wave -noupdate -divider -height 32 "Memory"
add wave -hex /stimulus/dut/mem/*

add list -hex -r /stimulus/*
add log -r /*

-- Set Wave Output Items 
TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ps} {75 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

-- Run the Simulation
run 620


