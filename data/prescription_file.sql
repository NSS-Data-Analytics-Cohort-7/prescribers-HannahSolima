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
SELECT p1.npi, SUM(total_claim_count) AS total_claim_count
FROM prescriber AS p1
JOIN prescription AS p2
USING (npi)
GROUP BY p1.npi
ORDER BY total_claim_count DESC;
---ANSWER: 1881634483 (npi), 99707 (total_claim_count)

---QUESTION 1.b
SELECT p1.npi, 
nppes_provider_first_name, 
nppes_provider_last_org_name, 
specialty_description,
SUM(total_claim_count) AS total_claim_count
FROM prescriber AS p1
JOIN prescription AS p2
ON p1.npi = p2.npi
GROUP BY p1.npi, 
nppes_provider_first_name, 
nppes_provider_last_org_name, 
specialty_description
ORDER BY total_claim_count DESC;
---ANSWER: Bruce Pendley, Family Practice (specialty description) 

---QUESTION 2.a
SELECT p1.specialty_description, SUM(total_claim_count) AS TotalClaimCount
FROM prescriber AS p1
JOIN prescription AS p2 
ON p1.npi = p2.npi
GROUP BY p1.specialty_description
ORDER BY SUM(total_claim_count) DESC;
---ANSWER: Family Practice, 9752347 (total_claim_count)

---QUESTION 2.b
SELECT p1.specialty_description, SUM(total_claim_count) AS claim_count
FROM prescriber AS p1
JOIN prescription AS p2 
USING (npi)
JOIN drug AS d
USING (drug_name)
WHERE opioid_drug_flag = 'Y'
GROUP BY p1.specialty_description
ORDER BY claim_count DESC;
---ANSWER: Nurse Practitioner, 900845 (claim_count)

---QUESTION 2.c (challenge question)
SELECT p1.specialty_description, SUM(p2.total_claim_count) AS TCC
FROM prescriber AS p1
LEFT JOIN prescription AS p2 
ON p1.npi = p2.npi
GROUP BY p1.specialty_description
ORDER BY TCC DESC;
---ANSWER: 15 specialities? 

---QUESTION 3.a 
SELECT generic_name, ROUND(SUM(total_drug_cost),2) AS total_drug_cost
FROM drug AS d
JOIN prescription AS p
USING (drug_name)
GROUP BY generic_name
ORDER BY total_drug_cost DESC;
---ANSWER: INSULIN, 104264066.35 (total_drug_cost)

---QUESTION 3.b 
SELECT generic_name, ROUND((SUM(total_drug_cost)/SUM(p.total_day_supply)),2) AS daily_cost
FROM drug AS d
JOIN prescription AS p
USING (drug_name)
GROUP BY generic_name
ORDER BY daily_cost DESC;
---ANSWER: C1 ESTERASE INHIBITOR, 3495.22 (daily cost)
                                                     
---QUESTION 4.a
SELECT drug_name, 
(CASE WHEN opioid_drug_flag = 'Y' 
    THEN 'opioid'
 WHEN antibiotic_drug_flag = 'Y'    
    THEN 'antibiotic' 
 ELSE 'NEITHER' END) AS drug_type
FROM drug AS d;
                        
---QUESTION 4.b 
SELECT (CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
 WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic' 
 ELSE 'NEITHER' END) AS drug_type, SUM(CAST(total_drug_cost AS money)) AS drug_cost
FROM drug AS d
JOIN prescription AS p
USING (drug_name)
GROUP BY drug_type
ORDER BY drug_cost DESC;
---ANSWER: Opioid, $105M

---QUESTION 5.a
SELECT DISTINCT cbsaname
FROM cbsa
WHERE cbsaname LIKE '%TN%';
---ANSWER: 10

---QUESTION 5.b
SELECT cbsaname, SUM(population) AS pop
FROM cbsa
JOIN population
USING (fipscounty)
GROUP BY cbsaname
ORDER BY pop DESC;
---ANSWER: "Nashville-Davidson--Murfreesboro--Franklin, TN", 1830410 (largest)
---Morristown,TN, 116352 (smallest)
                            
---QUESTION 5.c
SELECT fc.county AS county_name, SUM(p.population) AS total_pop
FROM population AS p
LEFT JOIN cbsa AS c
USING (fipscounty)  
JOIN fips_county AS fc
ON fc.fipscounty = p.fipscounty                            
WHERE c.fipscounty IS NULL
GROUP BY county_name                            
ORDER BY total_pop DESC;
                                                                                                                                      
---QUESTION 6.a
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >=3000
GROUP BY drug_name, total_claim_count
ORDER BY total_claim_count DESC;
---ANSWER: 9 rows 

---QUESTION 6.b 
SELECT drug_name, total_claim_count
FROM prescription
JOIN drug 
USING (drug_name)
WHERE total_claim_count >=3000 AND opioid_drug_flag = 'Y'   
GROUP BY drug_name, total_claim_count
ORDER BY total_claim_count DESC;   
---ANSWER: OXYCODONE HCL (4538), HYDROCODONE-ACE (3376)

---QUESTION 6.b
SELECT drug_name, total_claim_count,
(CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' ELSE 'NO' END) AS opioid
FROM prescription
JOIN drug 
USING (drug_name)
WHERE total_claim_count >=3000
ORDER BY total_claim_count DESC;
---same as above but also includes those that are not opioids

---QUESTION 6.c 
SELECT p2.drug_name, total_claim_count, nppes_provider_first_name, 
nppes_provider_last_org_name, 
(CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid' ELSE 'NO' END) AS opioid
FROM prescriber AS p1
JOIN prescription AS p2
USING (npi)
JOIN drug AS d
USING (drug_name)
WHERE total_claim_count >=3000
ORDER BY total_claim_count DESC;
---ANSWER: TABLE SHOWN? :)

---QUESTION 7.a
SELECT npi, drug_name
FROM prescriber 
CROSS JOIN drug 
WHERE nppes_provider_city = 'NASHVILLE' AND specialty_description LIKE '%Pain Management%' AND opioid_drug_flag = 'Y'

---QUESTION 7.b
SELECT p1.npi, d.drug_name, total_claim_count
FROM prescriber AS p1
CROSS JOIN drug AS d
LEFT JOIN prescription AS p2
USING (drug_name)
WHERE nppes_provider_city = 'NASHVILLE' AND specialty_description LIKE '%Pain Management%' AND opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC;

---QUESTION 7.c
SELECT p1.npi, d.drug_name, COELESCEtotal_claim_count
FROM prescriber AS p1
CROSS JOIN drug AS d
LEFT JOIN prescription AS p2
USING (drug_name)
WHERE nppes_provider_city = 'NASHVILLE' AND specialty_description LIKE '%Pain Management%' AND opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC;

