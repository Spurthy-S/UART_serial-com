# UART IP Core – Verilog

## 📖 Overview
A reusable **UART (Universal Asynchronous Receiver/Transmitter)** IP core written in **Verilog** and verified using **QuestaSim**.

## ⚡ Features
- Standard **N-8-1** format (No parity, 8 data bits, 1 stop bit)  
- Configurable baud rates (300–38400 bps)  
- Modular design: Baud Rate Generator, Receiver, Transmitter  
- Synthesizable for FPGA/ASIC  

## 📂 Project Structure
src/ → Verilog source files
│ ├── uart_brg.v # Baud Rate Generator
│ ├── transmitter.v # Transmitter
  │ ├── uart_brg.v # Baud Rate Generator
│ ├── uart_rx.v # Receiver
│ └── uart_top.v # Top-level integration
tb/ → Testbenches & QuestaSim scripts
│ └── tb_uart.v
