select * from {{ source("raw", "fact_returns") }}
