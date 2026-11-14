Warehouse : INSURANCE_WH
Database  : INSURANCE_DWH
Schema    : BRONZE

CUSTOMERS
AGENTS
POLICIES
CLAIMS

-- =====================================================
-- CREATE WAREHOUSE
-- =====================================================

CREATE WAREHOUSE IF NOT EXISTS INSURANCE_WH
WITH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

-- =====================================================
-- CREATE DATABASE
-- =====================================================

CREATE DATABASE IF NOT EXISTS INSURANCE_DWH;

USE DATABASE INSURANCE_DWH;

-- =====================================================
-- CREATE SCHEMAS
-- =====================================================

CREATE SCHEMA IF NOT EXISTS BRONZE;
CREATE SCHEMA IF NOT EXISTS SILVER;
CREATE SCHEMA IF NOT EXISTS GOLD;

-- =====================================================
-- USE CONTEXT
-- =====================================================

USE WAREHOUSE INSURANCE_WH;
USE DATABASE INSURANCE_DWH;
USE SCHEMA BRONZE;

-- =====================================================
-- CUSTOMERS TABLE
-- =====================================================

CREATE OR REPLACE TABLE BRONZE.CUSTOMERS
(
    CUSTOMER_ID INTEGER,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    GENDER STRING,
    DATE_OF_BIRTH DATE,
    EMAIL STRING,
    PHONE STRING,
    ADDRESS STRING,
    CITY STRING,
    STATE STRING,
    ZIP_CODE STRING,
    CREATED_AT TIMESTAMP,
    UPDATED_AT TIMESTAMP,
    _BATCH_ID STRING
);

-- =====================================================
-- AGENTS TABLE
-- =====================================================

CREATE OR REPLACE TABLE BRONZE.AGENTS
(
    AGENT_ID INTEGER,
    AGENT_NAME STRING,
    LICENSE_NUMBER STRING,
    REGION STRING,
    PHONE STRING,
    EMAIL STRING,
    HIRE_DATE DATE,
    COMMISSION_RATE NUMBER(5,2),
    CREATED_AT TIMESTAMP,
    UPDATED_AT TIMESTAMP,
    _BATCH_ID STRING
);

-- =====================================================
-- POLICIES TABLE
-- =====================================================

CREATE OR REPLACE TABLE BRONZE.POLICIES
(
    POLICY_ID INTEGER,
    POLICY_NUMBER STRING,
    CUSTOMER_ID INTEGER,
    AGENT_ID INTEGER,
    POLICY_TYPE STRING,
    PREMIUM_AMOUNT NUMBER(12,2),
    COVERAGE_AMOUNT NUMBER(12,2),
    START_DATE DATE,
    END_DATE DATE,
    POLICY_STATUS STRING,
    CREATED_AT TIMESTAMP,
    UPDATED_AT TIMESTAMP,
    _BATCH_ID STRING
);

-- =====================================================
-- CLAIMS TABLE
-- =====================================================

CREATE OR REPLACE TABLE BRONZE.CLAIMS
(
    CLAIM_ID INTEGER,
    POLICY_ID INTEGER,
    CUSTOMER_ID INTEGER,
    CLAIM_DATE DATE,
    INCIDENT_DATE DATE,
    PROCESSED_DATE DATE,
    CLAIM_AMOUNT NUMBER(12,2),
    APPROVED_AMOUNT NUMBER(12,2),
    CLAIM_STATUS STRING,
    FRAUD_FLAG BOOLEAN,
    CLAIM_DESCRIPTION STRING,
    CREATED_AT TIMESTAMP,
    UPDATED_AT TIMESTAMP,
    _BATCH_ID STRING
);

-- =====================================================
-- VERIFY
-- =====================================================

SHOW TABLES IN SCHEMA BRONZE;



---Run these Snowflake checks
SHOW DATABASES;
SHOW SCHEMAS IN DATABASE INSURANCE_DWH;
SHOW TABLES IN SCHEMA BRONZE;

---Airflow runs successfully, execute
SELECT COUNT(*) FROM BRONZE.CUSTOMERS;
SELECT COUNT(*) FROM BRONZE.AGENTS;
SELECT COUNT(*) FROM BRONZE.POLICIES;
SELECT COUNT(*) FROM BRONZE.CLAIMS;