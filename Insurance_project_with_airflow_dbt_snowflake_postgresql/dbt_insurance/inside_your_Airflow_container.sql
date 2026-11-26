### first login in airflow container then can we do .....

cat > models/silver/dim_customers.sql <<'EOF'
SELECT
    CUSTOMER_ID,

    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME,

    EMAIL,
    PHONE,

    DATE_OF_BIRTH,
    GENDER,
    CITY,
    STATE,
    ZIP_CODE,

    CREATED_AT::DATE AS REGISTRATION_DATE,

    DATEDIFF(
        YEAR,
        DATE_OF_BIRTH,
        CURRENT_DATE()
    ) AS AGE,

    CURRENT_TIMESTAMP() AS LOADED_AT

FROM {{ source('bronze', 'customers') }}
EOF



cat > models/silver/dim_agents.sql <<'EOF'
SELECT
    AGENT_ID,
    AGENT_NAME,
    LICENSE_NUMBER,
    EMAIL,
    PHONE,
    REGION,
    HIRE_DATE,
    COMMISSION_RATE,

    DATEDIFF(
        YEAR,
        HIRE_DATE,
        CURRENT_DATE()
    ) AS TENURE_YEARS,

    CURRENT_TIMESTAMP() AS LOADED_AT

FROM {{ source('bronze', 'agents') }}
EOF


cat > models/silver/dim_policies.sql <<'EOF'
SELECT
    POLICY_ID,
    CUSTOMER_ID,
    AGENT_ID,
    POLICY_NUMBER,
    POLICY_TYPE,

    COVERAGE_AMOUNT,
    PREMIUM_AMOUNT,

    START_DATE,
    END_DATE,

    POLICY_STATUS AS STATUS,

    CASE
        WHEN END_DATE >= CURRENT_DATE()
             AND POLICY_STATUS = 'ACTIVE'
        THEN TRUE
        ELSE FALSE
    END AS IS_ACTIVE,

    CURRENT_TIMESTAMP() AS LOADED_AT

FROM {{ source('bronze', 'policies') }}
EOF


cat > models/silver/fct_claims.sql <<'EOF'
SELECT
    C.CLAIM_ID,

    C.POLICY_ID,
    C.CUSTOMER_ID,
    P.AGENT_ID,

    C.CLAIM_DATE,
    C.INCIDENT_DATE,
    C.PROCESSED_DATE,

    C.CLAIM_AMOUNT,
    C.APPROVED_AMOUNT,

    C.CLAIM_STATUS,

    C.FRAUD_FLAG AS IS_FRAUDULENT,

    DATEDIFF(
        DAY,
        C.INCIDENT_DATE,
        C.PROCESSED_DATE
    ) AS PROCESSING_TIME_DAYS,

    CURRENT_TIMESTAMP() AS LOADED_AT

FROM {{ source('bronze', 'claims') }} C

LEFT JOIN {{ source('bronze', 'policies') }} P
    ON C.POLICY_ID = P.POLICY_ID
EOF



cat > models/gold/fraud_analytics.sql <<'EOF'
SELECT

    CLAIM_STATUS,

    COUNT(*) AS FRAUD_CASES,

    SUM(CLAIM_AMOUNT) AS FRAUD_AMOUNT,

    SUM(APPROVED_AMOUNT) AS FRAUD_APPROVED_AMOUNT,

    AVG(CLAIM_AMOUNT) AS AVG_FRAUD_CLAIM_AMOUNT

FROM {{ ref('fct_claims') }}

WHERE IS_FRAUDULENT = TRUE

GROUP BY CLAIM_STATUS
EOF