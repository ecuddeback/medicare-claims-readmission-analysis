-- Medicare Claims Analysis
-- Chronic Condition Burden
-- Question: How does the number of chronic conditions relate
-- to inpatient utilization and length of stay?

USE medicare_claims;

SELECT
    chronic_condition_count,
    COUNT(*) AS beneficiaries,
    ROUND(AVG(inpatient_claims), 2) AS avg_inpatient_claims,
    ROUND(SUM(total_payments), 2) AS total_payments,
    ROUND(AVG(avg_length_of_stay), 2) AS avg_length_of_stay
FROM (
    SELECT
        b.DESYNPUF_ID,

        (
            (b.SP_ALZHDMTA = 1) +
            (b.SP_CHF = 1) +
            (b.SP_CHRNKIDN = 1) +
            (b.SP_CNCR = 1) +
            (b.SP_COPD = 1) +
            (b.SP_DEPRESSN = 1) +
            (b.SP_DIABETES = 1) +
            (b.SP_ISCHMCHT = 1) +
            (b.SP_OSTEOPRS = 1) +
            (b.SP_RA_OA = 1) +
            (b.SP_STRKETIA = 1)
        ) AS chronic_condition_count,

        COUNT(i.CLM_ID) AS inpatient_claims,
        SUM(i.CLM_PMT_AMT) AS total_payments,
        AVG(i.CLM_UTLZTN_DAY_CNT) AS avg_length_of_stay

    FROM beneficiary b

    LEFT JOIN inpatient_claims i
        ON b.DESYNPUF_ID = i.DESYNPUF_ID

    GROUP BY
        b.DESYNPUF_ID,
        b.SP_ALZHDMTA,
        b.SP_CHF,
        b.SP_CHRNKIDN,
        b.SP_CNCR,
        b.SP_COPD,
        b.SP_DEPRESSN,
        b.SP_DIABETES,
        b.SP_ISCHMCHT,
        b.SP_OSTEOPRS,
        b.SP_RA_OA,
        b.SP_STRKETIA
) AS patient_summary

GROUP BY chronic_condition_count
ORDER BY chronic_condition_count;
