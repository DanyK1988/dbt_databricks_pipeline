with
    returns as (
        select sales_id, product_sk, return_reason, refund_amount
        from {{ ref("bronze_returns") }}
    ),
    products as (select product_sk, category from {{ ref("bronze_product") }}),
    joined_query as (
        select
            returns.sales_id,
            returns.refund_amount,
            returns.return_reason,
            products.category
        from returns
        left join products on returns.product_sk = products.product_sk

    )

select category, sum(refund_amount) as total_returns
from joined_query
group by category
order by category, total_returns desc
;
