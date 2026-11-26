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
