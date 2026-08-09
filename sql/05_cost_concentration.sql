-- Medicare Claims Analysis
-- Cost Concentration
-- Question: How concentrated are inpatient payments among beneficiaries?

USE medicare_claims;

WITH beneficiary_spending AS (
    SELECT
        DESYNPUF_ID,
        SUM(CLM_PMT_AMT) AS total_payment

    FROM inpatient_claims

    GROUP BY DESYNPUF_ID
),

ranked AS (
    SELECT
        DESYNPUF_ID,
        total_payment,

        NTILE(20) OVER (
            ORDER BY total_payment DESC
        ) AS spending_group

    FROM beneficiary_spending
)

SELECT
    'Top 5% of beneficiaries' AS group_name,
    COUNT(*) AS beneficiaries,
    ROUND(SUM(total_payment), 2) AS total_payments,

    ROUND(
        100 * SUM(total_payment) /
        (SELECT SUM(total_payment)
         FROM beneficiary_spending),
        2
    ) AS percent_of_total_spending

FROM ranked

WHERE spending_group = 1

UNION ALL

SELECT
    'Remaining 95% of beneficiaries',
    COUNT(*),
    ROUND(SUM(total_payment), 2),

    ROUND(
        100 * SUM(total_payment) /
        (SELECT SUM(total_payment)
         FROM beneficiary_spending),
        2
    )

FROM ranked

WHERE spending_group > 1;
