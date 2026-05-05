WITH source as (
	SELECT * FROM {{source('raw','customers')}}
),

renamed as (

SELECT 
  customer_id,
 first_name,
        last_name,
        email,
        country,
        age_band,
        acquisition_channel,
        employment_status,
CASE
            WHEN is_active = 'true' THEN TRUE
            ELSE FALSE
        END AS is_active,
    signup_date,
        created_at,
        updated_at

    FROM source

)

SELECT * FROM renamed
