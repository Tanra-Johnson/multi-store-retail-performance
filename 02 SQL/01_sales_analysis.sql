
USE multi_store_retail;

CREATE OR REPLACE VIEW vw_monthly_store_performance AS
WITH monthly_sales AS (
    SELECT
        STR_TO_DATE(
            DATE_FORMAT(sale_date, '%Y-%m-01'),
            '%Y-%m-%d'
        ) AS month_start,
        store_id,
        state_id,
        dept_id,
        cat_id,
        SUM(total_units_sold) AS total_units_sold,
        ROUND(SUM(total_revenue), 2) AS total_revenue,
        ROUND(
            SUM(total_revenue) / NULLIF(SUM(total_units_sold), 0),
            2
        ) AS average_selling_price
    FROM daily_store_performance_clean
    GROUP BY
        STR_TO_DATE(
            DATE_FORMAT(sale_date, '%Y-%m-01'),
            '%Y-%m-%d'
        ),
        store_id,
        state_id,
        dept_id,
        cat_id
),

monthly_comparison AS (
    SELECT
        *,
        LAG(total_revenue) OVER (
            PARTITION BY store_id, dept_id
            ORDER BY month_start
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    month_start,
    store_id,
    state_id,
    dept_id,
    cat_id,
    total_units_sold,
    total_revenue,
    average_selling_price,
    previous_month_revenue,
    ROUND(
        (
            total_revenue - previous_month_revenue
        ) / NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS month_over_month_growth_pct
FROM monthly_comparison;

SELECT *
FROM vw_monthly_store_performance
ORDER BY month_start, store_id, dept_id;