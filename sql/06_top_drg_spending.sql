-- Medicare Claims Analysis
-- Top DRG Spending
-- Question: Which DRG groups account for the greatest inpatient spending?

USE medicare_claims;

SELECT
    CLM_DRG_CD AS drg_code,
    COUNT(*) AS inpatient_claims,
    ROUND(SUM(CLM_PMT_AMT), 2) AS total_payments,
    ROUND(AVG(CLM_PMT_AMT), 2) AS avg_payment,
    ROUND(AVG(CLM_UTLZTN_DAY_CNT), 2) AS avg_length_of_stay

FROM inpatient_claims

WHERE CLM_DRG_CD IS NOT NULL

GROUP BY CLM_DRG_CD

ORDER BY total_payments DESC

LIMIT 10;
