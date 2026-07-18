
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

CREATE OR REPLACE VIEW vw_store_performance_summary AS
WITH store_summary AS (
    SELECT
        store_id,
        state_id,
        SUM(total_units_sold) AS total_units_sold,
        ROUND(SUM(total_revenue), 2) AS total_revenue,
        ROUND(
            SUM(total_revenue) / NULLIF(SUM(total_units_sold), 0),
            2
        ) AS average_selling_price,
        COUNT(DISTINCT sale_date) AS active_sales_days
    FROM daily_store_performance_clean
    GROUP BY store_id, state_id
)

SELECT
    store_id,
    state_id,
    total_units_sold,
    total_revenue,
    average_selling_price,
    active_sales_days,
    ROUND(
        total_revenue / SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_share_pct,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    RANK() OVER (
        ORDER BY total_units_sold DESC
    ) AS units_rank
FROM store_summary;

SELECT *
FROM vw_store_performance_summary
ORDER BY revenue_rank;

CREATE OR REPLACE VIEW vw_department_performance_summary AS
WITH department_summary AS (
    SELECT
        dept_id,
        cat_id,
        SUM(total_units_sold) AS total_units_sold,
        ROUND(SUM(total_revenue), 2) AS total_revenue,
        ROUND(
            SUM(total_revenue) / NULLIF(SUM(total_units_sold), 0),
            2
        ) AS average_selling_price,
        ROUND(AVG(total_revenue), 2) AS average_daily_revenue,
        COUNT(DISTINCT sale_date) AS active_sales_days
    FROM daily_store_performance_clean
    GROUP BY dept_id, cat_id
)

SELECT
    dept_id,
    cat_id,
    total_units_sold,
    total_revenue,
    average_selling_price,
    average_daily_revenue,
    active_sales_days,
    ROUND(
        total_revenue / SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_share_pct,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    RANK() OVER (
        ORDER BY total_units_sold DESC
    ) AS units_rank
FROM department_summary;

SELECT *
FROM vw_department_performance_summary
ORDER BY revenue_rank;

CREATE OR REPLACE VIEW vw_event_performance_summary AS
WITH daily_event_sales AS (
    SELECT
        sale_date,
        COALESCE(event_name_1, 'No Event') AS event_name,
        COALESCE(event_type_1, 'No Event') AS event_type,
        SUM(total_units_sold) AS daily_units_sold,
        ROUND(SUM(total_revenue), 2) AS daily_revenue
    FROM daily_store_performance_clean
    GROUP BY
        sale_date,
        COALESCE(event_name_1, 'No Event'),
        COALESCE(event_type_1, 'No Event')
)

SELECT
    event_name,
    event_type,
    COUNT(DISTINCT sale_date) AS number_of_days,
    SUM(daily_units_sold) AS total_units_sold,
    ROUND(SUM(daily_revenue), 2) AS total_revenue,
    ROUND(AVG(daily_revenue), 2) AS average_daily_revenue,
    RANK() OVER (
        ORDER BY AVG(daily_revenue) DESC
    ) AS revenue_rank
FROM daily_event_sales
GROUP BY event_name, event_type;

SELECT *
FROM vw_event_performance_summary
ORDER BY revenue_rank;

