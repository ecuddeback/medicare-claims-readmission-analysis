-- Medicare Claims Analysis
-- 30-Day Readmission Analysis
-- Question: What percentage of inpatient admissions are followed
-- by another admission within 30 days?

USE medicare_claims;

-- Overall 30-day readmission rate

WITH admissions AS (
    SELECT
        DESYNPUF_ID,
        CLM_ID,

        STR_TO_DATE(
            CAST(CLM_ADMSN_DT AS CHAR),
            '%Y%m%d'
        ) AS admission_date,

        LAG(
            STR_TO_DATE(
                CAST(CLM_ADMSN_DT AS CHAR),
                '%Y%m%d'
            )
        ) OVER (
            PARTITION BY DESYNPUF_ID
            ORDER BY CLM_ADMSN_DT
        ) AS previous_admission

    FROM inpatient_claims
)

SELECT
    COUNT(*) AS total_admissions,

    SUM(
        CASE
            WHEN previous_admission IS NOT NULL
             AND DATEDIFF(admission_date, previous_admission)
                 BETWEEN 1 AND 30
            THEN 1
            ELSE 0
        END
    ) AS readmissions_within_30_days,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN previous_admission IS NOT NULL
                 AND DATEDIFF(admission_date, previous_admission)
                     BETWEEN 1 AND 30
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct

FROM admissions

WHERE admission_date IS NOT NULL;


-- 30-day readmission rate by chronic-condition burden

WITH patient_conditions AS (
    SELECT
        DESYNPUF_ID,

        (
            (SP_ALZHDMTA = 1) +
            (SP_CHF = 1) +
            (SP_CHRNKIDN = 1) +
            (SP_CNCR = 1) +
            (SP_COPD = 1) +
            (SP_DEPRESSN = 1) +
            (SP_DIABETES = 1) +
            (SP_ISCHMCHT = 1) +
            (SP_OSTEOPRS = 1) +
            (SP_RA_OA = 1) +
            (SP_STRKETIA = 1)
        ) AS chronic_condition_count

    FROM beneficiary
),

admissions AS (
    SELECT
        i.DESYNPUF_ID,
        i.CLM_ID,
        pc.chronic_condition_count,

        STR_TO_DATE(
            CAST(i.CLM_ADMSN_DT AS CHAR),
            '%Y%m%d'
        ) AS admission_date,

        LAG(
            STR_TO_DATE(
                CAST(i.CLM_ADMSN_DT AS CHAR),
                '%Y%m%d'
            )
        ) OVER (
            PARTITION BY i.DESYNPUF_ID
            ORDER BY i.CLM_ADMSN_DT
        ) AS previous_admission

    FROM inpatient_claims i

    JOIN patient_conditions pc
        ON i.DESYNPUF_ID = pc.DESYNPUF_ID
)

SELECT
    chronic_condition_count,
    COUNT(*) AS total_admissions,

    SUM(
        CASE
            WHEN previous_admission IS NOT NULL
             AND DATEDIFF(admission_date, previous_admission)
                 BETWEEN 1 AND 30
            THEN 1
            ELSE 0
        END
    ) AS readmissions_30_days,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN previous_admission IS NOT NULL
                 AND DATEDIFF(admission_date, previous_admission)
                     BETWEEN 1 AND 30
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS readmission_rate_pct

FROM admissions

WHERE admission_date IS NOT NULL

GROUP BY chronic_condition_count
ORDER BY chronic_condition_count;
