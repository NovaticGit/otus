{{
    config(
        materialized='view'
    )
}}



WITH hist_tbl
AS
(
SELECT

c.customer_pk,
cd.first_name,
cd.last_name,
cd.email,
cd2.age, cd2.country,
cd.effective_from as cd_effective_from,
COALESCE(lead(cd.effective_from) OVER (PARTITION BY c.customer_pk ORDER BY cd.effective_from), '9999-12-31') AS cd_effective_to,
cd2.effective_from as cd2_effective_from,
COALESCE(lead(cd2.effective_from) OVER (PARTITION BY c.customer_pk ORDER BY cd2.effective_from), '9999-12-31') AS cd2_effective_to

FROM  dbt.hub_customer as c
LEFT JOIN dbt.sat_customer_details cd ON c.customer_pk = cd.customer_pk
LEFT JOIN dbt.sat_customer_details_crm cd2 ON c.customer_pk = cd.customer_pk
)
SELECT
customer_pk,
first_name,
last_name,
email, age, country,
cd_effective_from,
cd_effective_to,
cd2_effective_from,
cd2_effective_to
FROM hist_tbl
--WHERE current_timestamp BETWEEN cd_effective_from AND cd_effective_to
--WHERE current_timestamp BETWEEN cd2_effective_from AND cd2_effective_to