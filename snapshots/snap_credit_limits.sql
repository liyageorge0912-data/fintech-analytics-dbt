{% snapshot snap_credit_limits %}

{{
    config(
        target_schema='snapshots',
        unique_key='history_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

SELECT
    history_id,
    customer_id,
    credit_limit,
    change_reason,
    valid_from,
    updated_at
FROM {{ source('raw', 'credit_limit_history') }}

{% endsnapshot %}