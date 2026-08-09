USE WAREHOUSE compute_wh;
CREATE DATABASE test_ingestion;
CREATE OR REPLACE FILE FORMAT test_ingestion.public.csv_ff
type = 'csv';

DROP STAGE TEST_STAGE;

CREATE STAGE test_ingestion.public.test_stage url = 's3://sfquickstarts/tasty-bytes-builder-education/raw_pos/truck' file_format = csv_ff;

-- truck table build
CREATE OR REPLACE TABLE test_ingestion.public.truck
(
truck_id NUMBER(38,0),
menu_type_id NUMBER(38,0),
primary_city VARCHAR(16777216),
region VARCHAR(16777216),
iso_region VARCHAR(16777216),
country VARCHAR(16777216),
iso_country_code VARCHAR(16777216),
franchise_flag NUMBER(38,0),
year NUMBER(38,0),
make VARCHAR(16777216),
model VARCHAR(16777216),
ev_flag NUMBER(38,0),
franchise_id NUMBER(38,0),
truck_opening_date DATE
);

COPY INTO test_ingestion.public.truck
FROM @test_ingestion.public.test_stage
FILE_FORMAT = (FORMAT_NAME = 'test_ingestion.public.csv_ff')
ON_ERROR = 'CONTINUE';

LIST @test_ingestion.public.test_stage;

DROP DATABASE test_ingestion;

UNDROP DATABASE test_ingestion;

SHOW DATABASES;

USE DATABASE SF_TEST_DB;

DESCRIBE DATABASE SF_TEST_DB;

SELECT
t.*,
f.first_name AS franchisee_first_name,
f.last_name AS franchisee_last_name
FROM tasty_bytes.raw_pos.truck t
JOIN tasty_bytes.raw_pos.franchise f
ON t.franchise_id = f.franchise_id;

