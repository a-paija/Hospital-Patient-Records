-- Connect to database
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?

SELECT COUNT(e.START) AS total_encounters,
    YEAR(e.START) AS encounter_year
FROM encounters e
GROUP BY YEAR(e.START)
ORDER BY encounter_year;

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?

SELECT
    YEAR(e.START) AS encounter_year,
    e.ENCOUNTERCLASS,
    COUNT(*) AS class_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY YEAR(e.START)),
        2
    ) AS class_percentage
FROM encounters e
GROUP BY YEAR(e.START), e.ENCOUNTERCLASS
ORDER BY encounter_year, class_percentage DESC;

-- OR using CTE

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


-- c. What percentage of encounters were over 24 hours versus under 24 hours?

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

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?

SELECT
    COUNT(*) AS zero_coverage_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM encounters),
        2
    ) AS zero_coverage_percentage
FROM encounters
WHERE PAYER_COVERAGE = 0;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?

SELECT 
    p.DESCRIPTION AS `Procedure`,
    COUNT(*) AS procedure_count,
    ROUND(AVG(p.BASE_COST), 2) AS avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY procedure_count DESC
LIMIT 10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

SELECT
    p.DESCRIPTION as 'Procedure',
    count(*) as procedure_count,
    ROUND(AVG(p.BASE_COST), 2) as avg_base_cost
FROM procedures AS p
GROUP BY p.DESCRIPTION
ORDER BY avg_base_cost DESC
LIMIT 10;

-- d. What is the average total claim cost for encounters, broken down by payer?

SELECT
    e.PAYER,
    round(avg(e.TOTAL_CLAIM_COST),2) AS avg_total_claim_cost
FROM encounters as e
GROUP BY e.PAYER
ORDER BY avg_total_claim_cost DESC;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS
-- a. How many unique patients were admitted each quarter over time?

SELECT
    YEAR(e.START) AS encounter_year,
    QUARTER(e.START) AS encounter_quarter,
    COUNT(DISTINCT e.PATIENT) AS unique_patients
FROM encounters e
GROUP BY YEAR(e.START), QUARTER(e.START)
ORDER BY encounter_year, encounter_quarter;

-- b. How many patients were readmitted within 30 days of a previous encounter?

SELECT
    COUNT(DISTINCT e1.PATIENT) AS readmitted_patients_count
FROM encounters e1
JOIN encounters e2
    ON e1.PATIENT = e2.PATIENT
    AND e1.START > e2.STOP
    AND TIMESTAMPDIFF(DAY, e2.STOP, e1.START) <= 30;


-- c. Which patients had the most readmissions?

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
