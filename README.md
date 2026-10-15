# Low-Power ALU Design using Verilog ⚡

## Overview
This project is an industry-oriented VLSI digital design of a 32-bit Arithmetic Logic Unit (ALU). It goes beyond basic logic by implementing **power-aware RTL design techniques** to minimize dynamic switching power. Furthermore, the project includes a custom **Python Streamlit Web Dashboard** to automate compilation, simulation, and waveform visualization.

## VLSI Concepts Demonstrated
* **Parameterized RTL Design:** Configurable bit-width (default 32-bit).
* **Low-Power Microarchitecture:** 
  * *Operand Isolation:* Masking inputs to combinational blocks (like adders) when unused to prevent parasitic switching and dynamic power waste.
  * *RTL Clock Gating:* Using enable signals to prevent flip-flop toggling during idle states, preserving current state without consuming active power.
* **Functional Verification:** Self-checking testbench generation with VCD dumping.
* **Automated Tooling Pipeline:** Integrating legacy EDA tools with modern Python web frameworks.

## Supported Operations
The ALU supports 11 core operations, controlled by a 4-bit opcode:

| Opcode | Operation | Opcode | Operation |
|---|---|---|---|
| `0000` | ADD | `0110` | Shift Left |
| `0001` | SUB | `0111` | Shift Right |
| `0010` | AND | `1000` | Increment |
| `0011` | OR | `1001` | Decrement |
| `0100` | XOR | `1010` | Compare (A < B) |
| `0101` | NOT A | | |

## Project Structure
```text
Low-Power-ALU-Verilog/
│
├── rtl/
│   └── alu.v             # Core Verilog RTL module
├── tb/
│   └── alu_tb.v          # Self-checking testbench
├── simulation/           # Auto-generated outputs (VCD, logs)
├── app.py                # Streamlit Web Dashboard UI
├── run_sim.ps1           # CLI automation script (PowerShell)
└── README.md             # Project documentation

Tools & Tech Stack

    Hardware Description Language: Verilog / SystemVerilog

    Simulation Engine: Icarus Verilog (iverilog, vvp)

    Waveform Viewer: GTKWave

    Dashboard / UI: Python, Streamlit

    Synthesis (Optional): Xilinx Vivado (for Power/Utilization reporting)

How to Run the Simulation
Option 1: Using the Interactive Dashboard (Recommended)

You can run the entire compilation and simulation flow visually through the web browser.

    Ensure Icarus Verilog, GTKWave, and Python are installed and added to your system PATH.

    Install the Streamlit library:
    Bash

    pip install streamlit

    Launch the dashboard:
    Bash

    streamlit run app.py

    Navigate to the Run Simulation tab, click "Compile & Simulate," and then use the Waveform Analysis tab to launch GTKWave.

Option 2: Using the PowerShell Script

For a pure terminal-based flow:

    Open PowerShell in the project directory.

    Execute the script:
    PowerShell

    .\run_sim.ps1

Verification & Proof of Work

(Replace the placeholder text below with actual screenshots of your project once uploaded)

    📸 Dashboard View: [Add Screenshot of Streamlit UI]

    🌊 GTKWave Waveform: [Add Screenshot showing enable=0 holding the result steady]

    ⚙️ Vivado Synthesis (Optional): [Add Screenshot of Vivado schematic or power report]
