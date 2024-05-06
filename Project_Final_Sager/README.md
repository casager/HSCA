Course: High Speed Computer Arithmetic (ECEN 4233)
Author: Carson Sager
Title: Final Project

The goal of this project was to create a 32-bit IEEE 754 Divide Unit that uses Goldschmidt's Iteration to compute its operation.
Both round-to-nearest-even (RNE) and round-to-zero (RZ) rounding modes were tested successfully on the University of California-Berkeley (UCB) TestFloat test suite.

The following are the steps to running the SystemVerilog HDL for testing:

1. In a terminal, run "vsim -do fpdiv.do -c" (omit the "-c" to see the GUI while running from the shell) in order to use to ModelSim to test all vectors.
2. By default upon this submission, the testbench (tb_fpdiv.sv) is using f32_div_rz.tv for its current testing and .out file output(line 44/45). This also means that the rounding mode being used is RZ, which is used as input logic in the test bench file with rm = 1'b0 (line 65).
3. In order to change between RNE and RZ rounding modes, you must alter lines 44 and 45 so that they have the correct file names. For example, f32_div_rz.tv must be changed to f32_div_rne.tv if you would like to test RNE values. This also means that the output file should now change to f32_div_rne.out. Otherwise, the .out files will receive incorrect information corresponding to their naming. Note: *5000.tv files only contain 5000 of ~30,000 vectors. For full testing, do not use *5000.tv files.
4. After altering lines 44 and 45 of the testbench, the rounding mode must also be changed (line 65) to ensure that the correct rounding mode is being used with the correct testing set (rm = 0 for RZ, rm= 1 for RNE)
5. The .out file after running the testbench will be in the following format:

inputNumerator_inputDenominator_userAnswer | correctAnswer_userAnswer=correctAnswer? | rmMuxDecision | guard | remainderMSB

This format was used for debugging and ensuring that the correct answer was indeed found for each vector.
