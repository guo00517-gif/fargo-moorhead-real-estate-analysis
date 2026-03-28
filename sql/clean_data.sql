-- Step 1: Check for nulls
SELECT 
    COUNT(*) AS total_rows,
    COUNT(home_value) AS non_null_values,
    COUNT(*) - COUNT(home_value) AS null_values
FROM zillow_zhvi_fm_zip;

-- Step 2: Check date range
SELECT MIN(period_date), MAX(period_date)
FROM zillow_zhvi_fm_zip;

-- Step 3: Check zip codes and cities
SELECT DISTINCT region_name, state_name, metro
FROM zillow_zhvi_fm_zip
ORDER BY state_name;

-- Step 4: Create clean view
CREATE VIEW zillow_fm_clean AS
SELECT *
FROM zillow_zhvi_fm_zip
WHERE home_value IS NOT NULL
  AND region_name IS NOT NULL;

-- Step 5: Verify
SELECT COUNT(*) FROM zillow_fm_clean;