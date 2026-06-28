
<p align="center">
  <img src="https://github.com/vivekvkt/Azure-DataEngineering-Projects-2026/blob/main/Ecommerce-Platform-Snowflake-Analytics-Chatbot-projects/powerBIDahboard.PNG" width="900">
</p>

Phase 1: Infrastructure
Docker

✅ Docker Desktop

✅ Docker Compose

✅ PostgreSQL Container

✅ Airflow Containers

Webserver
Scheduler
Worker
Redis
Postgres
Phase 2: Airflow
ETL Pipeline

✅ Extract Customers

✅ Extract Agents

✅ Extract Policies

✅ Extract Claims

✅ Load Customers to Snowflake

✅ Load Agents to Snowflake

✅ Load Policies to Snowflake

✅ Load Claims to Snowflake

✅ Data Quality Validation

Phase 3: Snowflake
Database
INSURANCE_DWH
Schemas
BRONZE
SILVER
GOLD

✅ Created

Bronze Tables
CUSTOMERS
AGENTS
POLICIES
CLAIMS

✅ Loaded via Airflow

Phase 4: dbt
Sources
bronze.customers
bronze.agents
bronze.policies
bronze.claims

✅ Working

Silver Models
dim_customers
dim_agents
dim_policies
fct_claims

✅ Built Successfully

Gold Models
claim_summary
revenue_kpis
agent_performance
fraud_analytics

✅ Built Successfully

Testing
dbt test

✅ Working

Documentation
dbt docs generate

✅ Ready

Architecture Completed
PostgreSQL
    ↓
Airflow ETL
    ↓
Snowflake BRONZE
    ↓
dbt SILVER
    ↓
dbt GOLD
    ↓
Power BI