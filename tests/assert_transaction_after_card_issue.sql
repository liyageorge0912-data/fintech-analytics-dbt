SELECT
    t.transaction_id,
    t.customer_id,
    t.transaction_date,
    a.card_issued_at
FROM {{ ref('fct_transactions') }} t
JOIN {{ ref('fct_applications') }} a
    ON t.application_id = a.application_id
WHERE t.transaction_date < a.card_issued_at