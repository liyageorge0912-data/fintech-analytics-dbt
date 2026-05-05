WITH source AS (

    SELECT * FROM {{ source('raw', 'applications') }}

),

renamed AS (

    SELECT
        -- primary key
        application_id,

        -- foreign key
        customer_id,

        -- application details
        LOWER(decision)                    AS decision,
        requested_credit_limit,
        approved_credit_limit,

        -- dates
        applied_at,
        credit_check_at,
        decided_at,
        card_issued_at,
        created_at,
        updated_at

    FROM source

)

SELECT * FROM renamed