# UART IP Core – Verilog

## 📖 Overview
A reusable **UART (Universal Asynchronous Receiver/Transmitter)** IP core written in **Verilog** and verified using **QuestaSim**.

## ⚡ Features
- Standard **N-8-1** format (No parity, 8 data bits, 1 stop bit)  
- Configurable baud rates (300–38400 bps)  
- Modular design: Baud Rate Generator, Receiver, Transmitter  
- Synthesizable for FPGA/ASIC  

## 📂 Project Structure
```
src/ → Verilog source files
│ ├── brg.v # Baud Rate Generator
│ ├──transmitter.v # Transmitter
│ ├── receiver.v # Receiver

tb/ → Testbenches & QuestaSim scripts
│ └──receiver_tb.v
│ └──rtransmitter_tb.v


## ▶️ Simulation (QuestaSim)

### Compile sources
```tcl
vlib work
vlog src/*.v
vlog tb/*.v

```
## ▶️ Run testbenches (QuestaSim)
  >Receiver Testbench
  ```tcl
    vsim work.receiver_tb
    run -all
```

  >Transmitter Testbench
  ```tcl
    vsim work.transmitter_tb
    run -all
  ```

⚙️ Requirements
  >QuestaSim / ModelSim
  >Verilog simulator
  >(Optional) FPGA board for synthesis
📜 License

This project is licensed under the MIT License.staSim / ModelSim

Verilog simulator

(Optional) FPGA board for synthesis
