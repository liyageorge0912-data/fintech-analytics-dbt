WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2022-01-01' as date)",
        end_date="cast('2025-12-31' as date)"
    ) }}
),

final AS (
    SELECT
        DATE_PART('year', date_day) * 10000
        + DATE_PART('month', date_day) * 100
        + DATE_PART('day', date_day)                    AS date_id,
        date_day                                         AS full_date,
        DATE_PART('year', date_day)                      AS year,
        DATE_PART('quarter', date_day)                   AS quarter,
        DATE_PART('month', date_day)                     AS month_number,
        MONTHNAME(date_day)                              AS month_name,
        DATE_PART('week', date_day)                      AS week_number,
        DATE_PART('day', date_day)                       AS day_of_month,
        DATE_PART('dayofweek', date_day)                 AS day_of_week,
        DAYNAME(date_day)                                AS day_name,
        CASE
            WHEN DATE_PART('dayofweek', date_day) IN (0, 6)
            THEN TRUE ELSE FALSE
        END                                              AS is_weekend,
        TO_CHAR(date_day, 'YYYY-MM')                     AS year_month
    FROM date_spine
)

SELECT * FROM final