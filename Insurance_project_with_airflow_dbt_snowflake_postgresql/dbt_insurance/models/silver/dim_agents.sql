SELECT

    "agent_id" AS AGENT_ID,
    "agent_name" AS AGENT_NAME,
    "email" AS EMAIL,
    "region" AS REGION,

    TO_DATE(
        TO_TIMESTAMP_NTZ("hire_date" / 1000)
    ) AS HIRE_DATE,

    "performance_rating" AS PERFORMANCE_RATING,

    DATEDIFF(
        YEAR,
        TO_DATE(TO_TIMESTAMP_NTZ("hire_date" / 1000)),
        CURRENT_DATE()
    ) AS TENURE_YEARS,

    CURRENT_TIMESTAMP() AS LOADED_AT

FROM {{ source('bronze','agents') }}