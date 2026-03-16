# RISC-V Sequential Processor (RV64I)

A formal Verilog implementation of a sequential, non-pipelined RISC-V processor targeting a subset of the RV64I instruction set architecture.

## Overview

This project was developed as part of the Intro to Processor Architecture coursework at the International Institute of Information Technology, Hyderabad. The design implements a modular single-cycle datapath in Verilog and verifies the processor through module-level and top-level simulation.

The processor executes one instruction at a time without pipelining. As a result, the design avoids data and control hazard management while clearly exposing the fundamental stages of instruction execution: fetch, decode, execute, memory access, and write-back.

## Team

| Name | Roll Number |
|------|-------------|
| V. V. S. Aneesh | 2025122002 |
| M. Sai Poojith | 2025122010 |
| Anumay Rai | 2025122013 |

## Features

- Sequential, single-cycle RV64I-style processor datapath
- Modular Verilog implementation with dedicated testbenches
- 64-bit register file and ALU datapath
- Instruction fetch from external hex memory image
- Support for arithmetic, logical, memory, and branch instructions
- Top-level simulation output through waveform dump and register snapshot file

## Supported Instructions

| Instruction Type | Instructions |
|------------------|--------------|
| R-type | `add`, `sub`, `and`, `or` |
| I-type | `addi` |
| Load | `ld` |
| Store | `sd` |
| Branch | `beq` |

## Datapath Architecture

The datapath architecture used in the processor is shown below.

<p align="center">
  <img src="Datapath_Architecture/Datapath_Architecture_seq.png" alt="Datapath architecture of the sequential RISC-V processor" width="760" />
</p>

The datapath follows the standard single-cycle execution model:

1. The Program Counter supplies the instruction address.
2. Instruction Memory returns the 32-bit instruction.
3. The Control Unit decodes the opcode and generates control signals.
4. The Register File provides source operands.
5. The Immediate Generator and ALU Control prepare execution inputs.
6. The ALU performs arithmetic or logical computation.
7. Data Memory serves load and store instructions.
8. The selected result is written back to the destination register.

## Module Summary

| File | Description |
|------|-------------|
| `pc.v` | Program counter for instruction sequencing |
| `register_file.v` | 32 x 64-bit general-purpose register file |
| `Instruction_Memory.v` | Byte-addressed instruction memory initialized from `instructions.txt` |
| `control.v` | Main control unit for opcode decoding |
| `Immediate_Generation.v` | Sign-extension and immediate extraction logic |
| `alu_control.v` | ALU control signal generation |
| `alu.v` | 64-bit arithmetic and logic unit |
| `Data_Memory.v` | Byte-addressed data memory for `ld` and `sd` |
| `mux2_1.v` | 2:1 multiplexer used in datapath selection |
| `adder64.v` | 64-bit adder used for address and PC-related arithmetic |
| `sl1.v` | Shift-left-by-one unit for branch offset alignment |
| `and2.v` | Logical AND helper module |
| `seq.v` | Top-level sequential processor integration |

## Repository Structure

This repository uses a flat top-level layout rather than separate `src/` and `tb/` directories.

```text
RISC-V-PROCESSOR/
|-- README.md
|-- seq.v
|-- seq_tb.v
|-- pc.v
|-- pc_tb.v
|-- register_file.v
|-- register_file_tb.v
|-- Instruction_Memory.v
|-- Instruction_Memory_tb.v
|-- control.v
|-- control_tb.v
|-- Immediate_Generation.v
|-- Immediate_Generation_tb.v
|-- alu_control.v
|-- alu_control_tb.v
|-- alu.v
|-- alu_tb.v
|-- Data_Memory.v
|-- Data_Memory_tb.v
|-- mux2_1.v
|-- mux2_1_tb.v
|-- adder64.v
|-- adder64_tb.v
|-- sl1.v
|-- sl1_tb.v
|-- and2.v
|-- instructions.txt
|-- instructions_exp.txt
|-- Fibonacci_ins.txt
|-- Fibonacci_ins_exp.txt
|-- register_file.txt
|-- Fibonacci_register_file.txt
|-- Datapath_Architecture/
|   `-- Datapath_Architecture_seq.png
|-- IPA_Sequential_Project_Doc.pdf
|-- IPA_Sequential_Project_Report.pdf
`-- team_info.txt
```

## Input and Output Artifacts

| File | Purpose |
|------|---------|
| `instructions.txt` | Active instruction-memory image used by the top-level processor simulation |
| `instructions_exp.txt` | Human-readable explanation of the basic instruction test program |
| `Fibonacci_ins.txt` | Hex-encoded Fibonacci benchmark program |
| `Fibonacci_ins_exp.txt` | Human-readable explanation of the Fibonacci benchmark |
| `register_file.txt` | Register dump produced by the top-level simulation |
| `Fibonacci_register_file.txt` | Expected register dump for the Fibonacci benchmark |

## Simulation and Usage

### Prerequisites

- Icarus Verilog (`iverilog` and `vvp`)
- GTKWave for optional waveform inspection

### Running the Top-Level Processor

The top-level testbench writes a waveform file named `seq_tb.vcd` and a final register dump to `register_file.txt`.

```powershell
iverilog -o seq_sim seq_tb.v
vvp seq_sim
```

To inspect the waveform:

```powershell
gtkwave seq_tb.vcd
```

### Running Individual Module Testbenches

Each testbench includes its corresponding source file, so it can be compiled directly from the repository root.

Examples:

```powershell
iverilog -o adder64_sim adder64_tb.v
vvp adder64_sim

iverilog -o alu_sim alu_tb.v
vvp alu_sim
```

### Changing the Program Under Test

To run a different program on the sequential processor:

1. Replace the contents of `instructions.txt` with the required hex-encoded instruction stream.
2. Re-run the top-level simulation using `seq_tb.v`.
3. Inspect `register_file.txt` for the final register state.

## Verification Summary

The project includes dedicated testbenches for the core datapath modules as well as an integrated processor testbench.

### Basic Instruction Validation

The provided basic program validates arithmetic, logical, load/store, and branch behavior using the instruction sequence documented in `instructions_exp.txt`.

Representative observed outcomes include:

- `x1 = 15` after `add`
- `x2 = -5` after `sub`
- `x10 = 15` after `ld`
- `x11 = -5` after memory reload
- `x13 = 30` after the final arithmetic operation

### Fibonacci Benchmark

The repository also contains a Fibonacci benchmark program and its expected output files:

- `Fibonacci_ins.txt`
- `Fibonacci_ins_exp.txt`
- `Fibonacci_register_file.txt`

The expected result confirms correct iterative execution of the loop and correct branch behavior. In the supplied expected register dump, the final value corresponding to the 10th Fibonacci number is stored in `x3 = 55`, and the recorded instruction count is `60`.

## Documentation

Additional project documentation is included in the repository:

- `IPA_Sequential_Project_Report.pdf`
- `IPA_Sequential_Project_Doc.pdf`
- `Datapath_Architecture/Datapath_Architecture_seq.png`

## Conclusion

This project demonstrates the complete design and verification of a sequential RISC-V processor in Verilog. The repository is structured around modular datapath components, individual validation testbenches, and an integrated processor simulation flow. It serves both as a functional implementation and as a compact academic reference for single-cycle processor design.
