# ==============================================================================
# Script: run_sim.ps1
# Description: Automates the compilation, simulation, and waveform viewing
# ==============================================================================

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "  Low-Power ALU Verilog Simulation Flow       " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

$RTL_DIR = ".\rtl"
$TB_DIR = ".\tb"
$SIM_OUT_DIR = ".\simulation"
$OUTPUT_FILE = "$SIM_OUT_DIR\alu_sim.out"
$VCD_FILE = "$SIM_OUT_DIR\dump.vcd"

# Create the simulation folder
if (-Not (Test-Path -Path $SIM_OUT_DIR)) {
    New-Item -ItemType Directory -Path $SIM_OUT_DIR | Out-Null
    Write-Host "[INFO] Created simulation directory: $SIM_OUT_DIR" -ForegroundColor Green
}

if (-Not (Test-Path -Path $RTL_DIR) -or -Not (Test-Path -Path$TB_DIR)) {
    Write-Host "[ERROR] Directory '\rtl' or '\tb' not found." -ForegroundColor Red
    Exit
}

# 1. Compile using the Call Operator (&) to guarantee spaces are respected
Write-Host "`n[1/3] Compiling Verilog files..." -ForegroundColor Yellow
& iverilog -o $OUTPUT_FILE "$TB_DIR\alu_tb.v" "$RTL_DIR\alu.v"

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Compilation failed. Please check your Verilog syntax." -ForegroundColor Red
    Exit
} else {
    Write-Host "[SUCCESS] Compilation completed without errors." -ForegroundColor Green
}

# 2. Run simulation
Write-Host "`n[2/3] Running simulation..." -ForegroundColor Yellow
Push-Location -Path $SIM_OUT_DIR
& vvp ".\alu_sim.out"
Pop-Location

# Move VCD to correct folder
if (Test-Path ".\dump.vcd") {
    Move-Item -Path ".\dump.vcd" -Destination $VCD_FILE -Force
}

if (-Not (Test-Path -Path $VCD_FILE)) {
    Write-Host "[ERROR] Simulation failed or dump.vcd was not generated." -ForegroundColor Red
    Exit
} else {
    Write-Host "[SUCCESS] Simulation finished. Waveform file created at $VCD_FILE." -ForegroundColor Green
}

# 3. Open GTKWave
Write-Host "`n[3/3] Opening GTKWave..." -ForegroundColor Yellow
Start-Process -FilePath "gtkwave" -ArgumentList $VCD_FILE -NoNewWindow

Write-Host "`n==============================================" -ForegroundColor Cyan
Write-Host "  Flow Complete! Check the GTKWave window.    " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan