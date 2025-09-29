# Massachusetts General Hospital – Synthetic Patient Data (2011–2022)

This project analyzes **synthetic data** for approximately 1,000 patients from **Massachusetts General Hospital** between **2011–2022**.  
The dataset includes patient demographics, insurance coverage, medical encounters, and procedures.  

This project will explore healthcare utilization, costs, and patient behavior patterns using SQL queries.

---

## Objectives & Queries

### Objective 1: Encounters Overview
1. How many encounters occurred each year
2. How were they distributed across encounter classes?  
3. What percentage of encounters lasted more than 24 hours versus less than 24 hours?   

### Objective 2: Cost & Coverage Insights
1. How many encounters had zero payer coverage?
2. What are the most common procedures performed and their costs?
3. Which procedures are the most expensive on average?
4. What is the average claim cost by payer?

### Objective 3: Patient Behavior Analysis
1. How many unique patients were admitted each quarter?
2. How many patients were readmitted within 30 days?
3. Which patients had the most readmissions?

--- 

## Process 
- Designed SQL queries to analyze encounters, costs, coverage, and patient behavior.  
- Used grouping, filtering, and window functions for percentages and comparisons.  
- Organized results into three main objectives:  
  - Encounters Overview  
  - Cost & Coverage Insights  
  - Patient Behavior Analysis  

---

## Project Insight
- Yearly hospital encounters can highlight changes in demand for care.  
- Encounter class breakdown reveals differences between outpatient and inpatient utilization.  
- Zero coverage encounters show gaps in payer support.  
- Procedure frequency vs. cost highlights both **common care practices** and **high-cost risks**.  
- Readmission analysis provides insights into quality of care and patient outcomes.  

---

## SQL Queries

<details>
<summary><strong>Objective 1: Encounters Overview</strong></summary>

```sql
-- 1. Total encounters per year
SELECT COUNT(e.START) AS total_encounters,
       YEAR(e.START) AS encounter_year
FROM encounters e
GROUP BY YEAR(e.START)
ORDER BY encounter_year;

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

-- 2. Top 10 most frequent procedures and average base cost
SELECT 
    p.DESCRIPTION AS Procedure,
    COUNT(*) AS procedure_count,
    ROUND(AVG(p.BASE_COST), 2) AS avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY procedure_count DESC
LIMIT 10;

-- 3. Top 10 procedures by average base cost
SELECT
    p.DESCRIPTION AS Procedure,
    COUNT(*) AS procedure_count,
    ROUND(AVG(p.BASE_COST), 2) AS avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY avg_base_cost DESC
LIMIT 10;

-- 4. Average total claim cost by payer
SELECT
    e.PAYER,
    ROUND(AVG(e.TOTAL_CLAIM_COST), 2) AS avg_total_claim_cost
FROM encounters AS e
GROUP BY e.PAYER
ORDER BY avg_total_claim_cost DESC;
```
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

-- 2. Patients readmitted within 30 days
SELECT
    COUNT(DISTINCT e1.PATIENT) AS readmitted_patients_count
FROM encounters e1
JOIN encounters e2
    ON e1.PATIENT = e2.PATIENT
    AND e1.START > e2.STOP
    AND TIMESTAMPDIFF(DAY, e2.STOP, e1.START) <= 30;

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
</details>

## Final Conclusion
This project demonstrates how SQL can be used to analyze synthetic hospital data and uncover patterns in encounters, costs, and patient behavior.  
The findings can guide:  
- Operational planning for hospitals  
- Insurance and payer negotiations  
- Quality improvement initiatives (reducing readmissions, targeting high-cost procedures)  

---

## Data

[SyntheticMass](https://synthea.mitre.org/downloads)

License: Public Domain
