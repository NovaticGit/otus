{{
    config(
        materialized='table'
    )
}}

SELECT
date_trunc('week', od.order_date) as order_week,
od.status,
count(DISTINCT o.order_pk)
FROM {{ ref('hub_order') }} as o
LEFT JOIN {{ ref('sat_order_details') }} od ON o.order_pk = od.order_pk
group by 1, 2
order by 1 desc