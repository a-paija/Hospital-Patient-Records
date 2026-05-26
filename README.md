

## 🟦 Project Background

Modern healthcare systems generate large volumes of patient and operational data, yet much of it remains underutilized for decision-making. Hospitals often lack clear visibility into **patient flow, resource utilization, cost drivers, and care outcomes**, making it difficult to operate efficiently while maintaining quality of care.

This project analyzes a hospital patient dataset containing **encounters, procedures, demographics, and financial data** to uncover inefficiencies and identify opportunities to improve operational performance.

This project aims to:

1. Analyze patient volume and encounter trends  
2. Evaluate hospital utilization across encounter types and durations  
3. Identify high-cost procedures and financial risk areas  
4. Assess payer coverage and reimbursement patterns  
5. Measure patient behavior, including readmissions and care continuity  

#### **Overall Goal: Improve hospital efficiency, reduce operational strain, and enhance patient outcomes through data-driven decision-making.**

---

The full SQL script can be found [here](https://github.com/a-paija/Hospital-Patient-Records/blob/main/Hospital%20SQL%20Queries.sql) or at the bottom of this page.


## 🟦 Data Structure

The database structure as seen below consists of five tables: patients, encounters, procedures, payers and organizations, with a total row count of 27,891 records. Each record represents a single patient encounter along with the associated attributes.

<img src="Query Outputs/EDB.png" alt="ED1" width="700" height="450"/>



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



## 🟨 Hospital Utilization & Patient Flow

- Emergency and inpatient encounters drive a large share of volume  
- Long-duration encounters contribute to capacity constraints  
- Demand shows variation across time periods  


Operations are **capacity-constrained**, with inefficiencies in patient throughput limiting scalability.



## 🟨 Cost Drivers & Financial Risk

- High-frequency procedures significantly impact total costs  
- Certain treatments have disproportionately high average costs  
- Some encounters have zero payer coverage  


Financial performance is influenced by **cost concentration and inconsistent coverage**, increasing risk exposure.



## 🟨 Patient Behavior & Care Continuity

- Admissions vary seasonally and operationally  
- A subset of patients is readmitted within 30 days  
- Readmissions are concentrated among specific individuals  


Readmissions are driven by **gaps in care continuity**, not random variation.



## 🟧 Key Operational Risks

- Capacity strain from long-duration encounters  
- Financial exposure from uninsured patients  
- Cost concentration in specific procedures  
- Inefficient discharge and care coordination  
- Repeated readmissions from high-risk patients  



## 🟩 Strategic Recommendations

### **1. Improve Patient Throughput & Capacity Management**
**Impact:** High  
- Optimize discharge planning  
- Expand outpatient and follow-up care  
- Reduce long-duration stays  



### **2. Reduce Readmissions Through Targeted Care**
**Impact:** High  
- Implement follow-up programs  
- Focus on high-risk patients  
- Improve discharge education and adherence  



### **3. Strengthen Cost Control**
**Impact:** High  
- Standardize high-frequency procedures  
- Optimize staffing and resource allocation  
- Monitor cost variability  



### **4. Address Coverage Gaps**
**Impact:** Medium  
- Expand insurance support programs  
- Identify uninsured patient patterns  
- Improve payer strategy  



### **5. Align Staffing with Demand**
**Impact:** Medium  
- Adjust staffing for peak periods  
- Allocate resources by encounter type  
- Improve scheduling efficiency  



##  SQL Code


```sql
-- Connect to database
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- 1. How many total encounters occurred each year?

SELECT COUNT(e.START) AS total_encounters,
    YEAR(e.START) AS encounter_year
FROM encounters e
GROUP BY YEAR(e.START)
ORDER BY encounter_year;

-- 2. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?

WITH yearly AS (
    SELECT 
        YEAR(e.Start) AS encounter_year,
        e.EncounterClass
    FROM encounters e
)
SELECT
    encounter_year,
    EncounterClass,
    COUNT(*) AS class_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY encounter_year),
        2
    ) AS class_percentage
FROM yearly
GROUP BY encounter_year, EncounterClass
ORDER BY encounter_year, class_percentage DESC;


-- 3. What percentage of encount ers were over 24 hours versus under 24 hours?

SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(HOUR, e.Start, e.Stop) > 24 THEN 'Over 24 Hours'
        ELSE '24 Hours or Less'
    END AS duration_group,
    COUNT(*) AS encounter_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM encounters e
GROUP BY 
    CASE 
        WHEN TIMESTAMPDIFF(HOUR, e.Start, e.Stop) > 24 THEN 'Over 24 Hours'
        ELSE '24 Hours or Less'
    END;


-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- 1. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?

SELECT
    COUNT(*) AS zero_coverage_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM encounters),
        2
    ) AS zero_coverage_percentage
FROM encounters
WHERE PAYER_COVERAGE = 0;

-- 2. What are the top 10 most frequent procedures performed and the average base cost for each?

SELECT 
    p.DESCRIPTION AS `Procedure`,
    COUNT(*) AS procedure_count,
    ROUND(AVG(p.BASE_COST), 2) AS avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY procedure_count DESC
LIMIT 10;

-- 3. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

SELECT
    p.DESCRIPTION as 'Procedure',
    count(*) as procedure_count,
    ROUND(AVG(p.BASE_COST), 2) as avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY avg_base_cost DESC
LIMIT 10;

-- 4. What is the average total claim cost for encounters, broken down by payer?

SELECT
    e.PAYER,
    round(avg(e.TOTAL_CLAIM_COST),2) AS avg_total_claim_cost
FROM encounters as e
GROUP BY e.PAYER
ORDER BY avg_total_claim_cost DESC;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS
-- 1. How many unique patients were admitted each quarter over time?

SELECT
    YEAR(e.START) AS encounter_year,
    QUARTER(e.START) AS encounter_quarter,
    COUNT(DISTINCT e.PATIENT) AS unique_patients
FROM encounters e
GROUP BY YEAR(e.START), QUARTER(e.START)
ORDER BY encounter_year, encounter_quarter;

-- 2. How many patients were readmitted within 30 days of a previous encounter?

SELECT
    COUNT(DISTINCT e1.PATIENT) AS readmitted_patients_count
FROM encounters e1
JOIN encounters e2
    ON e1.PATIENT = e2.PATIENT
    AND e1.START > e2.STOP
    AND TIMESTAMPDIFF(DAY, e2.STOP, e1.START) <= 30;


-- 3. Which patients had the most readmissions?

SELECT
    e1.PATIENT,
    COUNT(*) AS readmission_count
FROM encounters e1
JOIN encounters e2
    ON e1.PATIENT = e2.PATIENT
    AND e1.START > e2.STOP
    AND TIMESTAMPDIFF(DAY, e2.STOP, e1.START) <= 30
GROUP BY e1.PATIENT
ORDER BY readmission_count DESC
LIMIT 10;
```

