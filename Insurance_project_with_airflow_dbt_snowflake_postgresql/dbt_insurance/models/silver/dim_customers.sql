SELECT

    "customer_id" AS CUSTOMER_ID,

    CONCAT(
        "first_name",
        ' ',
        "last_name"
    ) AS FULL_NAME,

    "email" AS EMAIL,
    "phone" AS PHONE,

    TO_DATE(
        TO_TIMESTAMP_NTZ("date_of_birth" / 1000)
    ) AS DATE_OF_BIRTH,

    "gender" AS GENDER,
    "city" AS CITY,
    "state" AS STATE,
    "zip_code" AS ZIP_CODE,

    TO_DATE(
        TO_TIMESTAMP_NTZ("registration_date" / 1000)
    ) AS REGISTRATION_DATE,

    DATEDIFF(
        YEAR,
        TO_DATE(TO_TIMESTAMP_NTZ("date_of_birth" / 1000)),
        CURRENT_DATE()
    ) AS AGE,

    CURRENT_TIMESTAMP() AS LOADED_AT

FROM {{ source('bronze','customers') }}