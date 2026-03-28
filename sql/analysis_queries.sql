-- Query 1: Most recent home value by zip code
SELECT 
    region_name AS zip_code,
    metro AS city,
    state_name,
    home_value
FROM zillow_fm_clean
WHERE period_date = (SELECT MAX(period_date) FROM zillow_fm_clean)
ORDER BY home_value DESC;

-- Query 2: Metro-wide median home value for reference
SELECT 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY home_value) AS fm_median_value
FROM zillow_fm_clean
WHERE period_date = (SELECT MAX(period_date) FROM zillow_fm_clean);

-- Query 3: Year-over-year home value change by zip code
SELECT 
    curr.region_name AS zip_code,
    curr.metro AS city,
    curr.state_name,
    ROUND(curr.home_value::NUMERIC, 0) AS current_value,
    ROUND(prev.home_value::NUMERIC, 0) AS prior_year_value,
    ROUND(
        (curr.home_value - prev.home_value) 
        / prev.home_value * 100, 1
    ) AS yoy_pct_change
FROM zillow_fm_clean curr
JOIN zillow_fm_clean prev
    ON curr.region_name = prev.region_name
    AND prev.period_date = '9/30/2024'
WHERE curr.period_date = '9/30/2025'
ORDER BY yoy_pct_change DESC;

-- Query 4: MN vs ND side comparison
SELECT 
    state_name,
    ROUND(AVG(home_value)::NUMERIC, 0) AS avg_home_value,
    COUNT(DISTINCT region_name) AS zip_count
FROM zillow_fm_clean
WHERE period_date = (SELECT MAX(period_date) FROM zillow_fm_clean)
GROUP BY state_name
ORDER BY avg_home_value DESC;

-- Query 5: WINDOW FUNCTION - Rank zip codes by value within each state
SELECT 
    region_name AS zip_code,
    metro AS city,
    state_name,
    ROUND(home_value::NUMERIC, 0) AS home_value,
    RANK() OVER (
        PARTITION BY state_name 
        ORDER BY home_value ASC
    ) AS affordability_rank
FROM zillow_fm_clean
WHERE period_date = (SELECT MAX(period_date) FROM zillow_fm_clean)
ORDER BY state_name, affordability_rank;

-- Query 6: PERCENT RANK - Where each zip sits in the overall metro
SELECT 
    region_name AS zip_code,
    metro AS city,
    state_name,
    ROUND(home_value::NUMERIC, 0) AS home_value,
    ROUND(
        PERCENT_RANK() OVER (ORDER BY home_value)::NUMERIC * 100, 1
    ) AS metro_percentile
FROM zillow_fm_clean
WHERE period_date = (SELECT MAX(period_date) FROM zillow_fm_clean)
ORDER BY metro_percentile ASC;

-- Query 7: CTE - Buy signal zip codes (below metro median, positive growth)
WITH yoy_growth AS (
    SELECT 
        curr.region_name AS zip_code,
        curr.metro AS city,
        curr.state_name,
        ROUND(curr.home_value::NUMERIC, 0) AS current_value,
        ROUND(
            (curr.home_value - prev.home_value) 
            / prev.home_value * 100, 1
        ) AS yoy_growth_pct
    FROM zillow_fm_clean curr
    JOIN zillow_fm_clean prev
        ON curr.region_name = prev.region_name
        AND prev.period_date = '9/30/2024'
    WHERE curr.period_date = '9/30/2025'
),
metro_median AS (
    SELECT PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY home_value) AS median_val
    FROM zillow_fm_clean
    WHERE period_date = (SELECT MAX(period_date) FROM zillow_fm_clean)
)
SELECT 
    g.zip_code,
    g.city,
    g.state_name,
    g.current_value,
    g.yoy_growth_pct,
    ROUND(m.median_val::NUMERIC, 0) AS metro_median,
    'Buy Signal' AS flag
FROM yoy_growth g, metro_median m
WHERE g.current_value < m.median_val
  AND g.yoy_growth_pct > 0
ORDER BY g.yoy_growth_pct DESC;

-- Query 8: CASE - Segment zip codes into market tiers
SELECT 
    region_name AS zip_code,
    metro AS city,
    state_name,
    ROUND(home_value::NUMERIC, 0) AS home_value,
    CASE 
        WHEN home_value < 270000 THEN 'Affordable'
        WHEN home_value BETWEEN 270000 AND 340000 THEN 'Mid-Market'
        WHEN home_value BETWEEN 340001 AND 400000 THEN 'Premium'
        ELSE 'Luxury'
    END AS market_tier,
    CASE
        WHEN home_value < 270000 THEN 'Entry Level'
        WHEN home_value BETWEEN 270000 AND 321252 THEN 'Below Metro Median'
        ELSE 'Above Metro Median'
    END AS metro_position
FROM zillow_fm_clean
WHERE period_date = (SELECT MAX(period_date) FROM zillow_fm_clean)
ORDER BY home_value DESC;