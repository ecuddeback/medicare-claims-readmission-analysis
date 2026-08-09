-- Medicare Claims Analysis
-- Baseline Inpatient Utilization Metrics
-- Question: What does the overall inpatient utilization picture look like?

USE medicare_claims;

SELECT
    COUNT(*) AS total_claims,
    COUNT(DISTINCT DESYNPUF_ID) AS unique_beneficiaries,
    ROUND(SUM(CLM_PMT_AMT), 2) AS total_claim_payments,
    ROUND(AVG(CLM_PMT_AMT), 2) AS avg_claim_payment,
    ROUND(AVG(CLM_UTLZTN_DAY_CNT), 2) AS avg_length_of_stay
FROM inpatient_claims;
