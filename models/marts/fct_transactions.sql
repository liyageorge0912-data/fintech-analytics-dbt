{{
    config(
        materialized='incremental',
        unique_key='transaction_id',
        incremental_strategy='merge'
    )
}}

WITH transactions AS (

    SELECT * FROM {{ ref('stg_transactions') }}

    {% if is_incremental() %}
        WHERE updated_at >= (
            SELECT DATEADD('day', -3, MAX(updated_at))
            FROM {{ this }}
        )
    {% endif %}

),

customers AS (

    SELECT
        customer_id,
        country,
        age_band,
        acquisition_channel
    FROM {{ ref('stg_customers') }}

),

final AS (

    SELECT
        -- primary key
        t.transaction_id,

        -- foreign keys
        t.customer_id,
        t.application_id,

        -- customer details
        c.country,
        c.age_band,
        c.acquisition_channel,

        -- transaction details
        t.amount,
        t.currency,
        t.merchant_category,
        t.status,

        -- derived fields
        CASE
            WHEN t.status = 'completed' THEN t.amount
            ELSE 0
        END                                     AS completed_amount,

        CASE
            WHEN t.status = 'refunded' THEN t.amount
            ELSE 0
        END                                     AS refunded_amount,

        -- dates
        t.transaction_date,
        t.created_at,
        t.updated_at

    FROM transactions t
    LEFT JOIN customers c
        ON t.customer_id = c.customer_id

)

SELECT * FROM final