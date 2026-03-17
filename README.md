
# Synchronous FIFO UVM Verification

This project implements a **complete UVM-based verification environment** for a **Synchronous FIFO**, focusing on functional correctness, corner-case validation, and coverage-driven verification using **SystemVerilog and Cadence Xcelium**.

---

#  Project Overview

The goal of this project is to verify a synchronous FIFO design using industry-standard verification methodologies including:

- UVM (Universal Verification Methodology)
- Constrained-Random Testing
- SystemVerilog Assertions (SVA)
- Functional & Code Coverage Analysis

---

#  Features

 1. Complete UVM Testbench Architecture  
 2.Driver, Monitor, Scoreboard Implementation  
 3. Constrained-Random Stimulus Generation  
 4. Assertion-Based Verification (SVA)  
 5. Functional Coverage Collection  
 6.Multiple Test Scenarios (normal, random, stress)  
 7.Coverage Analysis using Cadence IMC  

---

#  Verification Architecture

The UVM environment includes:

- **Sequence / Sequencer** → Generates stimulus  
- **Driver** → Drives DUT inputs  
- **Monitor** → Captures DUT activity  
- **Scoreboard** → Checks data correctness  
- **Coverage** → Tracks verification completeness  
- **Assertions (SVA)** → Validates protocol behavior  

---

#  DUT Description

The DUT is a **Synchronous FIFO** with:

- Parameterized depth (16 entries)
- Separate read and write pointers
- FIFO count tracking
- Status signals:
  - `full`
  - `empty`
- Supports:
  - Write operation
  - Read operation
  - Simultaneous read/write

---

#  Test Scenarios

The following tests were implemented:

###  Normal Test
- Basic write and read operations
- Validates FIFO functionality

###  Random Test
- Constrained-random read/write operations
- Covers different combinations of inputs

###  Stress Test
- Continuous operations under heavy load
- Tests corner cases like full and empty conditions

---

#  Coverage Results

| Metric              | Result        |
|--------------------|-------------|
| Overall Coverage   | **91.62%**  |
| Code Coverage      | **~90%**    |
| Assertion Coverage | **~87.5%**  |
| Testbench Coverage | **100%**    |

- Achieved high coverage through constrained-random testing and assertions.
Check RESULTS.md for more 
---

#  Coverage Report 

 - Check coverage_reports.md for it
---

