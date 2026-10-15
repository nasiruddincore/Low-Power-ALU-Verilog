# Low-Power ALU Design using Verilog ⚡

## Overview
This project is an industry-oriented VLSI digital design of a 32-bit Arithmetic Logic Unit (ALU). It goes beyond basic logic by implementing **power-aware RTL design techniques**—specifically Operand Isolation and Register Clock-Gating—to minimize dynamic switching power.

## VLSI Concepts Demonstrated
* **Parameterized RTL Design** (Configurable bit-width)
* **Combinational & Sequential Logic Partitioning**
* **Low-Power Design:** 
  * *Operand Isolation:* Masking inputs to combinational blocks (like adders) when unused to prevent parasitic switching.
  * *RTL Clock Gating:* Using enable signals to prevent flip-flop toggling during idle states.
* **Functional Verification:** Self-checking testbench generation.

## Supported Operations
| Opcode | Operation | Opcode | Operation |
|---|---|---|---|
| 0000 | ADD | 0110 | Shift Left |
| 0001 | SUB | 0111 | Shift Right |
| 0010 | AND | 1000 | Increment |
| 0011 | OR | 1001 | Decrement |
| 0100 | XOR | 1010 | Compare (A < B) |
| 0101 | NOT A | | |

## How to Simulate (No Installation Required)
1. Go to [EDA Playground](https://edaplayground.com).
2. Upload `alu.v` to the design window and `alu_tb.v` to the testbench window.
3. Select **Icarus Verilog 0.9.7** as the simulator.
4. Check **Open EPWave after run** and click **Run**.

## Project Proof
*(Add your screenshots here: Waveform, Vivado Synthesis Schematic, Power Report)*