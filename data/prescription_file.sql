SELECT *
FROM cbsa;

SELECT * 
FROM drug;

SELECT *
FROM fips_county;

SELECT *
FROM overdoses;

SELECT *
FROM population;

SELECT *
FROM prescriber;

SELECT *
FROM prescription;

SELECT *
FROM zip_fips;

---Question 1.a
SELECT p1.npi, total_claim_count
FROM prescriber AS p1
LEFT JOIN prescription AS p2
ON p1.npi = p2.npi
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC;
---ANSWER: 1912011792 (npi), 4538 (total_claim_count)

---QUESTION 1.b
SELECT p1.npi, total_claim_count, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description
FROM prescriber AS p1
LEFT JOIN prescription AS p2
ON p1.npi = p2.npi
WHERE total_claim_count IS NOT NULL 
ORDER BY total_claim_count DESC;
---ANSWER: DAVID COFFEY, Family Practice (specialty description) 

---QUESTION 2.a
SELECT p1.specialty_description, SUM(total_claim_count) AS TotalClaimCount
FROM prescriber AS p1
LEFT JOIN prescription AS p2 
ON p1.npi = p2.npi
WHERE total_claim_count IS NOT NULL 
GROUP BY p1.specialty_description
ORDER BY SUM(total_claim_count) DESC;
---ANSWER: Family Practice, 9752347 (total_claim_count)

---QUESTION 2.b
SELECT p1.specialty_description, COUNT(opioid_drug_flag) AS opioid_count
FROM prescriber AS p1
LEFT JOIN prescription AS p2 
USING (npi)
LEFT JOIN drug AS d
USING (drug_name)
WHERE total_claim_count IS NOT NULL
AND opioid_drug_flag = 'Y'
GROUP BY p1.specialty_description
ORDER BY opioid_count DESC;
---ANSWER: Nurse Practitioner, 9551 (opioid_count)

---QUESTION 2.c (challenge question)
SELECT p1.specialty_description, SUM(total_claim_count) AS TotalClaimCount
FROM prescriber AS p1
LEFT JOIN prescription AS p2 
ON p1.npi = p2.npi
WHERE total_claim_count IS NULL
GROUP BY p1.specialty_description;
---ANSWER: 92 specialities? 

---QUESTION 3.a 
SELECT generic_name, ROUND(MAX(total_drug_cost),0) AS total_drug_cost
FROM drug AS d
LEFT JOIN prescription AS p
USING (drug_name)
WHERE total_drug_cost IS NOT NULL
GROUP BY generic_name
ORDER BY total_drug_cost DESC;
---ANSWER: PIRENIDONE, 2829174

---QUESTION 3.b 
SELECT generic_name, ROUND(MAX(total_drug_cost)/365,2) AS daily_cost
FROM drug AS d
LEFT JOIN prescription AS p
USING (drug_name)
WHERE total_drug_cost IS NOT NULL
GROUP BY generic_name
ORDER BY daily_cost DESC;
---ANSWER: PIRFENIDONE, 7751.16 (daily cost)

---QUESTION 4.a
SELECT drug_name, 
(CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
 WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic' 
 ELSE 'NEITHER' END) AS drug_type
FROM drug AS d;

---QUESTION 4.b 

