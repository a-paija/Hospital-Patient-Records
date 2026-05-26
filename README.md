# 🏥 Hospital Patient Records & Operational Analysis (SQL)

## 🟦 Project Background

Modern healthcare systems generate large volumes of patient and operational data, yet much of it remains underutilized for decision-making. Hospitals often lack clear visibility into **patient flow, resource utilization, cost drivers, and care outcomes**, making it difficult to operate efficiently while maintaining quality of care.

This project analyzes a hospital patient dataset containing **encounters, procedures, demographics, and financial data** to uncover inefficiencies and identify opportunities to improve operational performance.

Without structured analysis, hospitals struggle to answer critical questions such as:
- Where operational bottlenecks occur across patient flow  
- Which services and departments drive demand  
- How efficiently patients are treated and discharged  
- Where financial risks and cost inefficiencies exist  
- Which patient segments are most at risk of readmission  

#### **Overall Goal: Improve hospital efficiency, reduce operational strain, and enhance patient outcomes through data-driven decision-making.**

This project transforms raw healthcare data into actionable insights using **SQL for deep diagnostic analysis**:

- SQL identifies **where inefficiencies occur**  
- Analysis explains **why they occur**  

---

## 🟦 Business Objectives & Analytical Focus

The primary objective is to evaluate **hospital operations, patient flow, and cost efficiency**.

This project aims to:

1. Analyze patient volume and encounter trends  
2. Evaluate hospital utilization across encounter types and durations  
3. Identify high-cost procedures and financial risk areas  
4. Assess payer coverage and reimbursement patterns  
5. Measure patient behavior, including readmissions and care continuity  

---

## 🟦 Data Structure & SQL Techniques

The database structure as seen below consists of five tables: patients, encounters, procedures, payers and organizations, with a total row count of 27,891 records. Each record represents a single patient encounter along with the associated attributes.

<img src="Query Outputs/EDB.png" alt="ED1" width="700" height="450"/>

---

## 🟩 Executive Summary

Hospital demand is strong, but performance is constrained by **capacity pressure, cost variability, and inefficiencies in patient flow and care continuity**.

Key findings:

- Patient volume is increasing, placing strain on resources  
- A portion of encounters exceeds 24 hours, indicating throughput inefficiencies  
- High-cost and high-frequency procedures drive overall cost structure  
- Some encounters lack payer coverage, increasing financial risk  
- 30-day readmissions highlight gaps in post-discharge care  

> **Core Insight:**  
> The hospital’s primary constraint is not demand, but the ability to efficiently manage patient flow, control costs, and ensure continuity of care.

---

## 🟨 Hospital Utilization & Patient Flow

- Emergency and inpatient encounters drive a large share of volume  
- Long-duration encounters contribute to capacity constraints  
- Demand shows variation across time periods  

#### **Business Insight**
Operations are **capacity-constrained**, with inefficiencies in patient throughput limiting scalability.

---

## 🟨 Cost Drivers & Financial Risk

- High-frequency procedures significantly impact total costs  
- Certain treatments have disproportionately high average costs  
- Some encounters have zero payer coverage  

#### **Business Insight**
Financial performance is influenced by **cost concentration and inconsistent coverage**, increasing risk exposure.

---

## 🟨 Patient Behavior & Care Continuity

- Admissions vary seasonally and operationally  
- A subset of patients is readmitted within 30 days  
- Readmissions are concentrated among specific individuals  

#### **Business Insight**
Readmissions are driven by **gaps in care continuity**, not random variation.

---

## 🟧 Key Operational Risks

- Capacity strain from long-duration encounters  
- Financial exposure from uninsured patients  
- Cost concentration in specific procedures  
- Inefficient discharge and care coordination  
- Repeated readmissions from high-risk patients  

---

## 🟩 Strategic Recommendations

### **1. Improve Patient Throughput & Capacity Management**
**Impact:** High  
- Optimize discharge planning  
- Expand outpatient and follow-up care  
- Reduce long-duration stays  

---

### **2. Reduce Readmissions Through Targeted Care**
**Impact:** High  
- Implement follow-up programs  
- Focus on high-risk patients  
- Improve discharge education and adherence  

---

### **3. Strengthen Cost Control**
**Impact:** High  
- Standardize high-frequency procedures  
- Optimize staffing and resource allocation  
- Monitor cost variability  

---

### **4. Address Coverage Gaps**
**Impact:** Medium  
- Expand insurance support programs  
- Identify uninsured patient patterns  
- Improve payer strategy  

---

### **5. Align Staffing with Demand**
**Impact:** Medium  
- Adjust staffing for peak periods  
- Allocate resources by encounter type  
- Improve scheduling efficiency  

---

## 📊 Insights & Recommendations Summary

| Insight | Recommendation |
|--------|--------------|
| Patient demand is increasing | Scale capacity and improve throughput |
| Long stays create bottlenecks | Optimize discharge and care coordination |
| High-cost procedures drive expenses | Standardize and control treatment costs |
| Some encounters lack coverage | Expand insurance and financial support |
| Readmissions are concentrated | Implement targeted care programs |
| Demand varies over time | Align staffing with demand patterns |

---

## 🔍 SQL Analysis & Code

- **Main SQL Queries:** *(insert link)*  
- **Exploratory Analysis:** *(insert link)*  

---
