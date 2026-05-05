WITH source AS (

    SELECT * FROM {{ source('raw', 'transactions') }}

),

renamed AS (

    SELECT
        -- primary key
        transaction_id,

        -- foreign keys
        customer_id,
        application_id,

        -- transaction details
        CAST(amount AS DECIMAL(10, 2))     AS amount,
        currency,
        LOWER(merchant_category)           AS merchant_category,
        LOWER(status)                      AS status,

        -- dates
        transaction_date,
        created_at,
        updated_at

    FROM source

)

SELECT * FROM renamed