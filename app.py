import streamlit as st
import subprocess
import os

# ==========================================
# Configuration & Directory Setup
# ==========================================
st.set_page_config(page_title="Low-Power ALU Dashboard", page_icon="⚡", layout="wide")

RTL_DIR = "rtl"
TB_DIR = "tb"
SIM_DIR = "simulation"
OUTPUT_FILE = os.path.join(SIM_DIR, "alu_sim.out")
VCD_FILE = os.path.join(SIM_DIR, "dump.vcd")

# Ensure simulation directory exists
os.makedirs(SIM_DIR, exist_ok=True)

# ==========================================
# Dashboard Header
# ==========================================
st.title("⚡ Low-Power ALU Verification Dashboard")
st.markdown("""
This dashboard provides a modern verification frontend for the **32-bit Low-Power Verilog ALU**. 
It automates the compilation, simulation, and waveform visualization pipeline using **Icarus Verilog** and **GTKWave**.
""")

# ==========================================
# Tabs Layout
# ==========================================
tab1, tab2, tab3 = st.tabs(["📝 Source Code", "🚀 Run Simulation", "🌊 Waveform Analysis"])

# --- TAB 1: SOURCE CODE VIEWER ---
with tab1:
    st.subheader("RTL & Testbench Viewer")
    col1, col2 = st.columns(2)
    
    with col1:
        st.markdown("**RTL Design (`rtl/alu.v`)**")
        if os.path.exists(os.path.join(RTL_DIR, "alu.v")):
            with open(os.path.join(RTL_DIR, "alu.v"), "r") as f:
                st.code(f.read(), language="verilog")
        else:
            st.error("Cannot find `rtl/alu.v`")

    with col2:
        st.markdown("**Testbench (`tb/alu_tb.v`)**")
        if os.path.exists(os.path.join(TB_DIR, "alu_tb.v")):
            with open(os.path.join(TB_DIR, "alu_tb.v"), "r") as f:
                st.code(f.read(), language="verilog")
        else:
            st.error("Cannot find `tb/alu_tb.v`")

# --- TAB 2: SIMULATION EXECUTION ---
with tab2:
    st.subheader("Icarus Verilog Simulation Engine")
    st.info("Clicking the button below will compile the RTL, run the testbench, and capture the output.")
    
    if st.button("▶️ Compile & Simulate", type="primary"):
        with st.spinner("Compiling Verilog..."):
            # 1. Compile
            compile_cmd = ["iverilog", "-o", OUTPUT_FILE, os.path.join(TB_DIR, "alu_tb.v"), os.path.join(RTL_DIR, "alu.v")]
            comp_process = subprocess.run(compile_cmd, capture_output=True, text=True)
            
            if comp_process.returncode != 0:
                st.error("Compilation Failed!")
                st.code(comp_process.stderr, language="bash")
            else:
                st.success("Compilation Successful!")
                
                # 2. Simulate
                with st.spinner("Running Simulation..."):
                    # FIX: Since cwd=SIM_DIR, we just pass the file name, not the folder path
                    sim_cmd = ["vvp", "alu_sim.out"]
                    
                    # Run vvp from the SIM_DIR so dump.vcd generates there natively
                    sim_process = subprocess.run(sim_cmd, capture_output=True, text=True, cwd=SIM_DIR)
                    
                    st.markdown("### Simulation Output (Console Logs)")
                    if sim_process.returncode == 0:
                        st.code(sim_process.stdout, language="bash")
                        st.success(f"Simulation completed. VCD dumped to `{VCD_FILE}`")
                    else:
                        st.error("Simulation Execution Failed")
                        st.code(sim_process.stderr, language="bash")

# --- TAB 3: WAVEFORM ANALYSIS ---
with tab3:
    st.subheader("GTKWave Integration")
    st.markdown("""
    The simulation generates a Value Change Dump (`.vcd`) file containing the exact timing and toggle logic of the ALU.
    Analyzing this waveform proves the **Operand Isolation** and **Clock Gating** features are actively reducing toggles when `enable = 0`.
    """)
    
    if os.path.exists(VCD_FILE):
        st.success("✅ Waveform data is ready for analysis.")
        if st.button("🌊 Launch GTKWave"):
            st.toast("Opening GTKWave in a new window...")
            # Launch GTKWave asynchronously
            subprocess.Popen(["gtkwave", VCD_FILE])
    else:
        st.warning("⚠️ No VCD file found. Please run the simulation in the previous tab first.")

# ==========================================
# Sidebar Info
# ==========================================
with st.sidebar:
    st.header("Project Specs")
    st.markdown("- **Architecture:** 32-bit")
    st.markdown("- **Low-Power Tech:** Clock Gating & Operand Isolation")
    st.markdown("- **Tools:** Icarus Verilog, GTKWave, Python")
    st.divider()
    st.markdown("*Developed for VLSI Portfolio*")