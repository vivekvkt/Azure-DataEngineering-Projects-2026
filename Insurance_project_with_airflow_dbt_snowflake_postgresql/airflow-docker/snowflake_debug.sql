-- Use admin role
USE ROLE ACCOUNTADMIN;

-- Create warehouse
CREATE OR REPLACE WAREHOUSE INSURANCE_WH
    WITH WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

USE WAREHOUSE INSURANCE_WH;
-- Create new database
CREATE DATABASE INSURANCE_DWH;
USE DATABASE INSURANCE_DWH;

-- Create schemas for Medallion Architecture
CREATE SCHEMA BRONZE;
CREATE SCHEMA SILVER;
CREATE SCHEMA GOLD;

USE SCHEMA INSURANCE_DWH.BRONZE;

-- BRONZE: Customers
CREATE TABLE BRONZE.CUSTOMERS (
    customer_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150),
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    registration_date DATE,
    created_at TIMESTAMP,
    _extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    _batch_id VARCHAR(100)
);

-- BRONZE: Agents
CREATE TABLE BRONZE.AGENTS (
    agent_id INT,
    agent_name VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(20),
    region VARCHAR(50),
    hire_date DATE,
    performance_rating DECIMAL(3,2),
    created_at TIMESTAMP,
    _extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    _batch_id VARCHAR(100)
);

-- BRONZE: Policies
CREATE TABLE BRONZE.POLICIES (
    policy_id INT,
    customer_id INT,
    policy_number VARCHAR(50),
    policy_type VARCHAR(50),
    coverage_amount DECIMAL(12,2),
    premium_amount DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    created_at TIMESTAMP,
    _extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    _batch_id VARCHAR(100)
);

-- BRONZE: Claims
CREATE TABLE BRONZE.CLAIMS (
    claim_id INT,
    claim_number VARCHAR(50),
    policy_id INT,
    customer_id INT,
    agent_id INT,
    claim_date DATE,
    incident_date DATE,
    claim_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    claim_status VARCHAR(30),
    claim_type VARCHAR(50),
    description TEXT,
    is_fraudulent BOOLEAN,
    processed_date DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    _extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    _batch_id VARCHAR(100)
);


USE SCHEMA INSURANCE_DWH.SILVER;

-- SILVER: Customers
CREATE TABLE SILVER.CUSTOMERS (
    customer_sk INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT,
    full_name VARCHAR(200),
    email VARCHAR(150),
    phone VARCHAR(20),
    date_of_birth DATE,
    age INT,
    age_group VARCHAR(20),
    gender VARCHAR(10),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    registration_date DATE,
    customer_tenure_years INT,
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- SILVER: Agents
CREATE TABLE SILVER.AGENTS (
    agent_sk INT AUTOINCREMENT PRIMARY KEY,
    agent_id INT,
    agent_name VARCHAR(150),
    email VARCHAR(150),
    region VARCHAR(50),
    hire_date DATE,
    tenure_years INT,
    performance_rating DECIMAL(3,2),
    performance_category VARCHAR(20),
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- SILVER: Policies
CREATE TABLE SILVER.POLICIES (
    policy_sk INT AUTOINCREMENT PRIMARY KEY,
    policy_id INT,
    customer_id INT,
    policy_number VARCHAR(50),
    policy_type VARCHAR(50),
    coverage_amount DECIMAL(12,2),
    premium_amount DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    is_active BOOLEAN,
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- SILVER: Claims
CREATE TABLE SILVER.CLAIMS (
    claim_sk INT AUTOINCREMENT PRIMARY KEY,
    claim_id INT,
    claim_number VARCHAR(50),
    policy_id INT,
    customer_id INT,
    agent_id INT,
    claim_date DATE,
    incident_date DATE,
    claim_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    claim_status VARCHAR(30),
    claim_type VARCHAR(50),
    is_fraudulent BOOLEAN,
    processing_time_days INT,
    _loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);


USE SCHEMA INSURANCE_DWH.GOLD;

-- DIM: Date
CREATE TABLE GOLD.DIM_DATE (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_of_week INT,
    day_name VARCHAR(10),
    month INT,
    month_name VARCHAR(10),
    quarter INT,
    year INT,
    is_weekend BOOLEAN
);

-- DIM: Customer
CREATE TABLE GOLD.DIM_CUSTOMER (
    customer_key INT PRIMARY KEY,
    customer_id INT,
    full_name VARCHAR(200),
    email VARCHAR(150),
    age INT,
    age_group VARCHAR(20),
    gender VARCHAR(10),
    city VARCHAR(100),
    state VARCHAR(50),
    _loaded_at TIMESTAMP
);

-- DIM: Agent
CREATE TABLE GOLD.DIM_AGENT (
    agent_key INT PRIMARY KEY,
    agent_id INT,
    agent_name VARCHAR(150),
    region VARCHAR(50),
    tenure_years INT,
    performance_rating DECIMAL(3,2),
    performance_category VARCHAR(20),
    _loaded_at TIMESTAMP
);

-- DIM: Policy
CREATE TABLE GOLD.DIM_POLICY (
    policy_key INT PRIMARY KEY,
    policy_id INT,
    policy_number VARCHAR(50),
    policy_type VARCHAR(50),
    coverage_amount DECIMAL(12,2),
    premium_amount DECIMAL(10,2),
    status VARCHAR(20),
    _loaded_at TIMESTAMP
);



USE SCHEMA INSURANCE_DWH.GOLD;

-- FACT: Claims
CREATE TABLE GOLD.FACT_CLAIMS (
    claim_key INT PRIMARY KEY,
    claim_id INT,
    claim_number VARCHAR(50),
    customer_key INT,
    agent_key INT,
    policy_key INT,
    claim_date_key INT,
    claim_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    claim_status VARCHAR(30),
    claim_type VARCHAR(50),
    is_fraudulent BOOLEAN,
    processing_time_days INT,
    _loaded_at TIMESTAMP
);

-- AGG: Daily Summary
CREATE TABLE GOLD.AGG_DAILY_CLAIMS (
    summary_date DATE PRIMARY KEY,
    total_claims INT,
    total_claim_amount DECIMAL(15,2),
    total_approved_amount DECIMAL(15,2),
    approval_rate DECIMAL(5,2),
    fraud_claims_count INT,
    _loaded_at TIMESTAMP
);



-- Check all schemas
SHOW SCHEMAS IN DATABASE INSURANCE_DWH;

-- Check BRONZE tables
SHOW TABLES IN SCHEMA INSURANCE_DWH.BRONZE;

-- Check SILVER tables
SHOW TABLES IN SCHEMA INSURANCE_DWH.SILVER;

-- Check GOLD tables
SHOW TABLES IN SCHEMA INSURANCE_DWH.GOLD;

-- Summary
SELECT 'BRONZE' as layer, COUNT(*) as tables FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'BRONZE'
UNION ALL
SELECT 'SILVER', COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'SILVER'
UNION ALL
SELECT 'GOLD', COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'GOLD';

SHOW TABLES IN SCHEMA BRONZE;

SELECT COUNT(*) 
FROM BRONZE.agents;
--0

SELECT COUNT(*) 
FROM BRONZE.claims;
--0

SELECT COUNT(*) 
FROM BRONZE.customers;
--0

TRUNCATE TABLE BRONZE.CUSTOMERS;
TRUNCATE TABLE BRONZE.AGENTS;
TRUNCATE TABLE BRONZE.POLICIES;
TRUNCATE TABLE BRONZE.CLAIMS;


SELECT COUNT(*) FROM BRONZE.CUSTOMERS;
--0
SELECT COUNT(*) FROM BRONZE.AGENTS;
--0
SELECT COUNT(*) FROM BRONZE.POLICIES;
--0
SELECT COUNT(*) FROM BRONZE.CLAIMS;
--0

USE WAREHOUSE INSURANCE_WH;

SHOW WAREHOUSES;
-- compute_wh
-- insurance_wh
-- system$streamlit

SHOW SCHEMAS IN DATABASE INSURANCE_DWH

USE ROLE ACCOUNTADMIN;

GRANT OWNERSHIP
ON TABLE INSURANCE_DWH.BRONZE.CUSTOMERS
TO ROLE AIRFLOW_ROLE
COPY CURRENT GRANTS;

GRANT OWNERSHIP
ON TABLE INSURANCE_DWH.BRONZE.AGENTS
TO ROLE AIRFLOW_ROLE
COPY CURRENT GRANTS;

GRANT OWNERSHIP
ON TABLE INSURANCE_DWH.BRONZE.POLICIES
TO ROLE AIRFLOW_ROLE
COPY CURRENT GRANTS;

GRANT OWNERSHIP
ON TABLE INSURANCE_DWH.BRONZE.CLAIMS
TO ROLE AIRFLOW_ROLE
COPY CURRENT GRANTS;


USE ROLE ACCOUNTADMIN;
GRANT SELECT ON ALL TABLES IN SCHEMA INSURANCE_DWH.BRONZE TO ROLE ACCOUNTADMIN;

GRANT SELECT ON ALL TABLES IN SCHEMA INSURANCE_DWH.SILVER TO ROLE ACCOUNTADMIN;

GRANT SELECT ON ALL TABLES IN SCHEMA INSURANCE_DWH.GOLD TO ROLE ACCOUNTADMIN;

SELECT COUNT(*) FROM INSURANCE_DWH.BRONZE.CUSTOMERS;
--20
SELECT COUNT(*) FROM INSURANCE_DWH.BRONZE.AGENTS;
--5
SELECT COUNT(*) FROM INSURANCE_DWH.BRONZE.POLICIES;
--0
SELECT COUNT(*) FROM INSURANCE_DWH.BRONZE.CLAIMS;