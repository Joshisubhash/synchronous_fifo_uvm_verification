# 📘 Coverage Report – Cadence IMC

This section presents the **coverage analysis results** of the Synchronous FIFO UVM verification using **Cadence IMC (Integrated Metrics Center)**.

The results demonstrate **code coverage, assertion coverage, and hierarchical coverage distribution** across the verification environment.

---

## 📊 Overall Coverage Summary

![Overall Coverage](./images/image1.png)

**Description:**  
This screenshot shows the **top-level coverage summary**.

Key observations:
- **Overall Coverage:** 91.62%
- **Covered Points:** 184 / 204 (90.2%)
- **Assertion Coverage:** 75%

This indicates that most of the RTL logic and verification scenarios are covered.

---

## 📊 Coverage Context & Environment

![Coverage Context](./images/image2.png)

**Description:**  
This view shows the **coverage environment details**.

Highlights:
- Coverage collected from UVM simulation run
- Includes model files and UCD database
- No refinement or exclusion rules applied

This ensures that the coverage results are **unfiltered and accurate**.

---

## 📊 Instance-Level Coverage (tb Breakdown)

![Instance Coverage](./images/image3.png)

**Description:**  
This screenshot shows coverage inside the **testbench hierarchy (`tb`)**.

Coverage details:
- **Interface (vif):** 88.46%
- **DUT:** 90.52%
- **Assertions:** 87.5%

This confirms that both DUT behavior and assertions are well verified.

---

## 📊 Instance Hierarchy View

![Instance Hierarchy](./images/image4.png)

**Description:**  
This view shows coverage across different instances.

Observations:
- `uvm_pkg` and `$unit` have no coverage (expected)
- `tb` contributes majority of coverage
- Active components are fully exercised

---

## 📊 Type-Level Coverage Breakdown

![Type Coverage](./images/image5.png)

**Description:**  
This screenshot shows coverage categorized by design blocks.

Breakdown:
- **Testbench:** 100%
- **FIFO Interface:** 88.46%
- **FIFO DUT:** 90.52%
- **Assertions:** 87.5%

This demonstrates strong verification across all major components.

---

# ✅ Coverage Summary

✔ Overall Coverage: **91.62%**  
✔ Code Coverage: **~90%**  
✔ Assertion Coverage: **~87.5% (internal), 75% graded**  
✔ Testbench Coverage: **100%**

---

# 🚀 Key Takeaways

- Comprehensive verification using **UVM methodology**
- Effective use of **SystemVerilog Assertions (SVA)**
- Strong coverage across DUT, interface, and testbench
- Verification environment successfully validates multiple scenarios

---

# 👨‍💻 Author

**Subhash Joshi**  
Digital Design & Verification Enthusiast  

---
