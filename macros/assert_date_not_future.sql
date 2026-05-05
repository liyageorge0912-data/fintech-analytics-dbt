{% test assert_date_not_future(model, column_name) %}

SELECT
    {{ column_name }} AS failing_value
FROM {{ model }}
WHERE {{ column_name }} > CURRENT_DATE

{% endtest %}