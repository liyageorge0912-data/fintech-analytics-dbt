{% test assert_column_a_after_column_b(model, column_name, compare_column) %}

SELECT
    {{ column_name }}    AS failing_value,
    {{ compare_column }} AS compare_value
FROM {{ model }}
WHERE {{ column_name }} IS NOT NULL
AND   {{ compare_column }} IS NOT NULL
AND   {{ column_name }} <= {{ compare_column }}

{% endtest %}