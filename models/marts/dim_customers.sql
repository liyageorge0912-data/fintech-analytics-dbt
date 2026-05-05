WITH customers AS (

    SELECT * FROM {{ ref('stg_customers') }}

),

applications AS (

    SELECT
        customer_id,
        application_id,
        decision,
        approved_credit_limit,
        applied_at,
        card_issued_at
    FROM {{ ref('stg_applications') }}
    WHERE decision = 'approved'

),

final AS (

    SELECT
        -- primary key
        c.customer_id,

        -- customer details
        c.first_name,
        c.last_name,
        c.email,
        c.country,
        c.age_band,
        c.acquisition_channel,
        c.employment_status,
        c.is_active,

        -- application details
        a.application_id,
        a.approved_credit_limit,
        a.applied_at,
        a.card_issued_at,

        -- derived fields
        CASE
            WHEN a.customer_id IS NOT NULL THEN TRUE
            ELSE FALSE
        END                                     AS has_credit_card,

        DATEDIFF('day', c.signup_date, a.card_issued_at) 
                                                AS days_to_card_issue,

        -- dates
        c.signup_date,
        c.created_at,
        c.updated_at

    FROM customers c
    LEFT JOIN applications a
        ON c.customer_id = a.customer_id

)

SELECT * FROM final