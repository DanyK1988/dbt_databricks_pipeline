with
    dedup_query as (
        select
            *,
            row_number() over (
                partition by id order by updatedate desc
            ) as deduplicated_row
        from {{ source("raw", "items") }}
    )
select *
from dedup_query
where deduplicated_row = 1
