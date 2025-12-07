# 🏥 Hospital Patient Records & Analysis (SQL)

## 📌 Project Overview
This project analyzes hospital patient records to uncover operational inefficiencies, identify high-risk patient segments, and support data-driven decision-making around staffing, treatment performance, and patient outcomes.

## 🎯 Business Questions Addressed
```
1. How many patients were admitted, and what are the overall admission trends?
2. Which days and months experience the highest patient volume?
3. Which medical conditions drive the most hospital visits?
4. What are the average patient wait times, treatment durations, and length of stay?
5. Which departments are over- or under-utilized?
6. What patient demographics (age, gender) are associated with higher admission rates?
7. What percentage of patients required critical or emergency care?
8. What diagnoses and treatments contribute most to hospital throughput?
```
## 🗂️ Data and Tech Stack
```
- Patient demographics  
- Admission & discharge timestamps  
- Medical condition / diagnosis  
- Treatment type & duration  
- Department information  
- Outcome (recovered, discharged, further care, etc.)
```
```
- CTEs  
- Window functions  
- Aggregations  
- Date/time manipulation  
- Joins  
- Subqueries  
- Ranking functions  
- Case statements  
```
---


## 🎯 Project Objectives & Key Questions

### Objective 1: Hospital Encounters Overview

- **Annual Volume:** How many encounters occurred each year, and what does this reveal about trends in hospital demand?  
- **Encounter Types:** How are encounters distributed across inpatient, outpatient, and emergency categories?  
- **Duration Analysis:** What percentage of encounters lasted over 24 hours versus 24 hours or less, and what patterns emerge from these durations?  

### Objective 2: Cost & Coverage Insights

- **Coverage Gaps:** How many encounters had zero payer coverage, and what does this indicate about insurance support?  
- **Procedure Frequency:** Which medical procedures are most frequently performed, and what are their associated costs?  
- **High-Cost Procedures:** Which procedures are the most expensive on average, highlighting potential areas of financial risk?  
- **Payer Costs:** What is the average claim cost by payer, and how can this inform contracting and reimbursement strategies?  

### Objective 3: Patient Behavior & Outcomes

- **Quarterly Admissions:** How many unique patients were admitted each quarter, and how does this reflect seasonal or operational patterns?  
- **Readmission Rates:** How many patients were readmitted within 30 days, indicating potential gaps in care continuity?  
- **Frequent Readmissions:** Which patients experienced the most readmissions, and what insights can be drawn for patient care management?  

---

## Exploratory Analaysis and Code Snippets (Click to Open)

<details>
<summary><strong>Objective 1: Encounters Overview</strong></summary>

```sql
-- 1. Total encounters per year
SELECT COUNT(e.START) AS total_encounters,
       YEAR(e.START) AS encounter_year
FROM encounters e
GROUP BY YEAR(e.START)
ORDER BY encounter_year;

```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective1.1_encounters_by_year.png" alt="Encounters by Year" width="300" height="300"/>

```sql


-- 2. Percentage of encounters by encounter class
WITH yearly AS (
    SELECT YEAR(e.Start) AS encounter_year,
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

```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective1.2_encounters_by_class.png" alt="Encounters by Class" width="400" height="500"/>

```sql

-- 3. Encounters over vs. under 24 hours
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
```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective1.3_encounters_by_duration.png" alt="Encounters by Duration" width="300" height="300"/>

<h2>Recommendations</h2>

- If encounters are rising → hospital needs to scale capacity (staff, beds, outpatient programs).

- If emergency visits dominate → invest in outpatient/wellness clinics to reduce ER strain.

- If long stays are common → investigate discharge planning, home health, or care coordination programs.

---

</details>
<details> <summary><strong>Objective 2: Cost & Coverage Insights</strong></summary>

```sql
-- 1. Encounters with zero payer coverage
SELECT
    COUNT(*) AS zero_coverage_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM encounters),
        2
    ) AS zero_coverage_percentage
FROM encounters
WHERE PAYER_COVERAGE = 0;

```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective2.1_zero_coverage_encounters.png" alt="zero_coverage_encounters" width="300" height="300"/>

```sql
-- 2. Top 10 most frequent procedures and average base cost
SELECT 
    p.DESCRIPTION AS Procedure,
    COUNT(*) AS procedure_count,
    ROUND(AVG(p.BASE_COST), 2) AS avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY procedure_count DESC
LIMIT 10;
```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective2.2_common_procedures_costs.png" alt="Common Procedures" width="500" height="800"/>

```sql

-- 3. Top 10 procedures by average base cost
SELECT
    p.DESCRIPTION AS Procedure,
    COUNT(*) AS procedure_count,
    ROUND(AVG(p.BASE_COST), 2) AS avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY avg_base_cost DESC
LIMIT 10;

```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective2.3_expensive_procedures_avg.png" alt="Expensive Procedures" width="500" height="800"/>

```sql
-- 4. Average total claim cost by payer
SELECT
    e.PAYER,
    ROUND(AVG(e.TOTAL_CLAIM_COST), 2) AS avg_total_claim_cost
FROM encounters AS e
GROUP BY e.PAYER
ORDER BY avg_total_claim_cost DESC;
```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective2.4_avg_claim_cost_by_payer.png" alt="Avg Claim" width="300" height="300"/>

<h2>Recommendations</h2>

- Explore financial assistance or insurance enrollment programs to reduce uninsured encounters.

- Optimize supply chains, staffing, and standardization around high-frequency procedures.

- Review billing/reimbursement rates for high-cost procedures to avoid underpayment.

- Use claim cost by payer to guide payer contracting strategy (push for fairer rates).

---

</details>

<details> <summary><strong>Objective 3: Patient Behavior Analysis</strong></summary>
  
```sql
-- 1. Unique patients admitted each quarter
SELECT
    YEAR(e.START) AS encounter_year,
    QUARTER(e.START) AS encounter_quarter,
    COUNT(DISTINCT e.PATIENT) AS unique_patients
FROM encounters e
GROUP BY YEAR(e.START), QUARTER(e.START)
ORDER BY encounter_year, encounter_quarter;
```
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective3.1_unique_patients_by_quarter.png" alt="Quarter" width="300" height="300"/>

```sql

-- 2. Patients readmitted within 30 days
SELECT
    COUNT(DISTINCT e1.PATIENT) AS readmitted_patients_count
FROM encounters e1
JOIN encounters e2
    ON e1.PATIENT = e2.PATIENT
    AND e1.START > e2.STOP
    AND TIMESTAMPDIFF(DAY, e2.STOP, e1.START) <= 30;
```

<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective3.2_30day_readmissions.png" alt="30" width="150" height="150"/>

```sql

-- 3. Patients with the most readmissions
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
<img src="https://github.com/a-paija/Hospital-Patient-Records/blob/main/Summarized%20Outputs/objective3.3_patients_most_readmissions.png" alt="Most" width="300" height="300"/>

<h2>Recommendations</h2>

- Staff planning around seasonal peaks (temporary nurses, flu-shot campaigns).

- Implement readmission reduction programs (follow-up calls, medication adherence checks, discharge education).

- Develop chronic disease management programs for high-risk patients to cut readmissions and costs.

---

</details>

## 📊 Insights & Recommendations Summary

| **Insight** | **Recommendation** |
|------------|------------------|
| Yearly hospital encounters are rising. | Scale hospital capacity: increase staff, beds, and outpatient programs to meet demand. |
| Emergency visits dominate overall encounters. | Invest in outpatient clinics and wellness programs to reduce ER strain. |
| A subset of encounters last over 24 hours. | Review discharge planning, home health, and care coordination to optimize length of stay. |
| Some encounters have zero payer coverage. | Implement financial assistance programs and promote insurance enrollment. |
| High-frequency procedures vary in cost. | Standardize procedures, optimize supply chains, and staff efficiently around common procedures. |
| Certain procedures are extremely expensive on average. | Audit high-cost procedures, ensure accurate billing, and renegotiate payer rates if needed. |
| Average claim costs vary by payer. | Use cost analysis to guide payer contracting strategy and reimbursement optimization. |
| Unique patient admissions peak mid-week and during winter months. | Plan staff schedules seasonally and for mid-week peaks to maintain operational efficiency. |
| 30-day readmissions occur for a subset of patients. | Implement readmission reduction programs: follow-up calls, medication adherence checks, discharge education. |
| Patients with frequent readmissions identified. | Develop chronic disease management programs and targeted care plans for high-risk patients. |
| Older age groups (65+) account for the highest admissions. | Allocate geriatric-specific resources and care programs to meet patient needs. |
| Length of stay varies by diagnosis and acuity. | Tailor care pathways by diagnosis to improve efficiency and patient outcomes. |

---

## ✅ Final Summary
This SQL project provides a full operational view of hospital performance, helping administrators identify bottlenecks, optimize staffing levels, improve patient flow, and enhance quality of care. The findings offer a foundation for predictive analytics and future dashboard development.

Data Source: [SyntheticMass](https://synthea.mitre.org/downloads)

License: Public Domain
