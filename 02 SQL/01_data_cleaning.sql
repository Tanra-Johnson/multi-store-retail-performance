CREATE DATABASE multi_store_retail;
USE multi_store_retail;

USE multi_store_retail;

SELECT COUNT(*) AS row_count
FROM daily_store_performance_v2;

SELECT
    `date`,
    COUNT(*) AS rows_for_date
FROM daily_store_performance
GROUP BY `date`
HAVING COUNT(*) <> 6
ORDER BY `date`;

SELECT
    store_id,
    `ï»¿dept_id`,
    COUNT(*) AS row_count
FROM daily_store_performance
GROUP BY store_id, `ï»¿dept_id`
ORDER BY store_id, `ï»¿dept_id`;

DROP TABLE daily_store_performance;

RENAME TABLE daily_store_performance_v2
TO daily_store_performance;

RENAME TABLE daily_store_performance_v2
TO daily_store_performance;

SELECT COUNT(*) AS row_count
FROM daily_store_performance;

SHOW TABLES;

RENAME TABLE daily_store_performance
TO daily_store_performance_raw;

CREATE TABLE daily_store_performance_clean AS
SELECT
    `ï»¿dept_id` AS dept_id,
    STR_TO_DATE(`date`, '%m/%d/%Y') AS sale_date,
    CAST(wm_yr_wk AS UNSIGNED) AS wm_yr_wk,
    weekday,
    store_id,
    state_id,
    cat_id,
    NULLIF(event_name_1, '') AS event_name_1,
    NULLIF(event_type_1, '') AS event_type_1,
    NULLIF(event_name_2, '') AS event_name_2,
    NULLIF(event_type_2, '') AS event_type_2,
    CAST(snap_TX AS UNSIGNED) AS snap_TX,
    CAST(total_units_sold AS UNSIGNED) AS total_units_sold,
    CAST(total_revenue AS DECIMAL(14,2)) AS total_revenue,
    CAST(average_selling_price AS DECIMAL(10,2)) AS average_selling_price
FROM daily_store_performance_raw;

SELECT
    COUNT(*) AS row_count,
    MIN(sale_date) AS first_date,
    MAX(sale_date) AS last_date,
    SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS invalid_dates
FROM daily_store_performance_clean;

SELECT
    sale_date,
    store_id,
    dept_id,
    COUNT(*) AS duplicate_count
FROM daily_store_performance_clean
GROUP BY sale_date, store_id, dept_id
HAVING COUNT(*) > 1;

SELECT
    sale_date,
    COUNT(*) AS rows_per_date
FROM daily_store_performance_clean
GROUP BY sale_date
HAVING COUNT(*) <> 6;

SELECT
    SUM(total_units_sold < 0) AS negative_units,
    SUM(total_revenue < 0) AS negative_revenue,
    SUM(average_selling_price < 0) AS negative_prices,
    SUM(store_id IS NULL OR store_id = '') AS missing_stores,
    SUM(dept_id IS NULL OR dept_id = '') AS missing_departments
FROM daily_store_performance_clean;

SELECT DISTINCT
    store_id,
    dept_id,
    cat_id
FROM daily_store_performance_clean
ORDER BY store_id, dept_id;
