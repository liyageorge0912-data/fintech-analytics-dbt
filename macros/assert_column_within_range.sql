{% test assert_column_within_range(model, column_name, min_value, max_value) %}

SELECT
    {{ column_name }} AS failing_value
FROM {{ model }}
WHERE {{ column_name }} < {{ min_value }}
OR    {{ column_name }} > {{ max_value }}

{% endtest %}