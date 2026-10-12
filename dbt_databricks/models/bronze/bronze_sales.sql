select * from {{ source("raw", "fact_sales") }}
