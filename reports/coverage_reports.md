# 📘 Coverage Report – Cadence IMC (FIFO UVM Verification)

This section presents the **coverage analysis results** of the Synchronous FIFO verification using **UVM + SystemVerilog Assertions (SVA)** on Cadence Xcelium.

📂 Full Interactive HTML Report:  
👉 [Open Coverage Report](./html/index.html)

---

## 📊 1. Overall Coverage Summary

![Overall Coverage](./images/Screenshot_2026-03-17_184553.png)

**Description:**  
This is the **top-level coverage report** showing overall verification quality.

- Overall Coverage: **91.62%**
- Covered Points: **184 / 204 (90.2%)**
- Assertion Coverage: **75%**

✔ Indicates strong functional and code coverage across the design.

---

## 📊 2. Coverage Hierarchy View

![Hierarchy](./images/Screenshot 2026-03-17_184600.png)

🔗 HTML View: [Verification Metrics Tree](./html/node_1.html) :contentReference[oaicite:0]{index=0}  

**Description:**  
Shows hierarchical breakdown into:
- **Types**
- **Instances**

✔ Helps understand how coverage is distributed structurally.

---

## 📊 3. Types-Based Coverage Breakdown

![Types Coverage](./images/Screenshot 2026-03-17 184607.png)

🔗 HTML View: [Types Breakdown](./html/node_2.html) :contentReference[oaicite:1]{index=1}  

**Description:**  
Coverage categorized by design components:

- Testbench (tb): **100%**
- FIFO Interface: **88.46%**
- FIFO DUT: **90.52%**
- Assertions: **87.5%**

✔ Confirms each module is independently verified.

---

## 📊 4. Instance-Level Coverage

![Instance Coverage](./images/Screenshot 2026-03-17 184612.png)

🔗 HTML View: [Instances View](./html/node_9.html) :contentReference[oaicite:2]{index=2}  

**Description:**  
Breakdown across instances:

- `uvm_pkg`, `$unit` → n/a (expected)
- `tb` → main contributor

✔ Shows active verification happens inside testbench.

---

## 📊 5. Testbench Internal Coverage

![TB Coverage](./images/Screenshot 2026-03-17 184626.png)

🔗 HTML View: [TB Internal View](./html/node_12.html) :contentReference[oaicite:3]{index=3}  

**Description:**  
Detailed coverage inside testbench:

- Interface (vif): **88.46%**
- DUT: **90.52%**
- Assertions: **87.5% (75% graded)**

✔ Confirms correctness of DUT behavior using assertions.

---

# ✅ Final Coverage Summary

| Metric                | Value        |
|----------------------|-------------|
| Overall Coverage     | **91.62%**  |
| Code Coverage        | **~90%**    |
| Assertion Coverage   | **~87.5%**  |
| Testbench Coverage   | **100%**    |

---

# 🚀 Key Highlights

- Built complete **UVM Verification Environment**
- Implemented **Constrained-Random Testing**
- Integrated **SystemVerilog Assertions (SVA)**
- Achieved **90%+ functional and code coverage**
- Verified FIFO across multiple scenarios:
  - Normal operation
  - Random stress testing
  - Corner cases (full/empty conditions)

---

# ⚠️ Note

GitHub does not render Cadence IMC HTML reports properly due to:
- External CSS (`resources/`)
- JavaScript dependencies

👉 Use the provided **HTML links locally** for full interactive analysis.

---

# 👨‍💻 Author

**Subhash Joshi**  
Digital Design & Verification Engineer (Aspiring)

---
