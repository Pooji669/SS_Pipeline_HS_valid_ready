# Single-Stage Valid/Ready Pipeline Register (SystemVerilog)

## Overview
This repository contains a single-stage pipeline register implemented in
SystemVerilog using a standard valid/ready handshake protocol.

The module accepts input data when `in_valid` and `in_ready` are asserted,
stores it internally, and presents it on the output interface with `out_valid`.
Backpressure is handled correctly without data loss or duplication.

## Design Features
- Fully synthesizable RTL
- Standard valid/ready handshake
- Correct backpressure handling
- Clean reset to empty state

## Interface Behavior
- Data is accepted when `in_valid && in_ready`
- Output data is valid when `out_valid == 1`
- Data is held stable when `out_ready == 0`

## File Structure
- rtl/pipeline_reg.sv - RTL implementation
- tb/pipeline_reg_tb.sv - Basic testbench


## Simulation
The design can be simulated using tools such as:
- EDA Playground
- ModelSim / Questa

## Author
Poojitha
