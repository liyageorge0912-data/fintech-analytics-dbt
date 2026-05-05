WITH applications AS (

    SELECT * FROM {{ ref('stg_applications') }}

),

customers AS (

    SELECT
        customer_id,
        country,
        age_band,
        acquisition_channel,
        employment_status
    FROM {{ ref('stg_customers') }}

),

final AS (

    SELECT
        -- primary key
        a.application_id,

        -- foreign keys
        a.customer_id,

        -- customer details
        c.country,
        c.age_band,
        c.acquisition_channel,
        c.employment_status,

        -- application details
        a.decision,
        a.requested_credit_limit,
        a.approved_credit_limit,

        -- derived fields
        CASE
            WHEN a.decision = 'approved' THEN 1
            ELSE 0
        END                                         AS is_approved,

        DATEDIFF('day', a.applied_at, a.decided_at) 
                                                    AS days_to_decision,

        DATEDIFF('day', a.applied_at, a.card_issued_at)
                                                    AS days_to_card_issue,

        -- dates
        a.applied_at,
        a.credit_check_at,
        a.decided_at,
        a.card_issued_at,
        a.created_at,
        a.updated_at

    FROM applications a
    LEFT JOIN customers c
        ON a.customer_id = c.customer_id

)

SELECT * FROM final