WITH source AS (

    SELECT * FROM {{ source('raw', 'credit_limit_history') }}

),

renamed AS (

    SELECT
        history_id,
        customer_id,
        CAST(credit_limit AS DECIMAL(10, 2))   AS credit_limit,
        LOWER(change_reason)                    AS change_reason,    
        valid_from,
        updated_at
    FROM source

)

SELECT * FROM renamed