select * from {{ source("raw", "dim_customer") }}
