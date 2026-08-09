-- Medicare Claims Analysis
-- Data Validation
-- Purpose: Confirm the size and basic structure of the datasets.

USE medicare_claims;

-- Confirm beneficiary record count
SELECT COUNT(*) AS beneficiary_rows
FROM beneficiary;

-- Confirm inpatient claim record count
SELECT COUNT(*) AS inpatient_rows
FROM inpatient_claims;

-- Review sample inpatient records
SELECT *
FROM inpatient_claims
LIMIT 5;

-- Review sample beneficiary records
SELECT *
FROM beneficiary
LIMIT 5;

-- Review the date range of inpatient claims
SELECT
    MIN(CLM_ADMSN_DT) AS earliest_admission,
    MAX(CLM_ADMSN_DT) AS latest_admission,
    MIN(NCH_BENE_DSCHRG_DT) AS earliest_discharge,
    MAX(NCH_BENE_DSCHRG_DT) AS latest_discharge
FROM inpatient_claims;
