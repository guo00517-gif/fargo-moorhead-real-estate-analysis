CREATE TABLE zillow_zhvi_fm_zip (
    region_id           INT,
    size_rank           INT,
    region_name         VARCHAR(20),
    region_type         VARCHAR(20),
    state_name          VARCHAR(5),
    state               VARCHAR(5),
    metro               VARCHAR(100),
    state_code_fips     VARCHAR(5),
    municipal_code_fips VARCHAR(10),
    period_date         VARCHAR(20),
    home_value          NUMERIC(12,2)
);