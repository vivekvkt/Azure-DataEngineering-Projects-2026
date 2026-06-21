SELECT

    c.customer_id,

    f.total_revenue

FROM {{ ref('dim_customer') }} c

LEFT JOIN {{ ref('fct_revenue') }} f

ON c.customer_id = f.customer_id