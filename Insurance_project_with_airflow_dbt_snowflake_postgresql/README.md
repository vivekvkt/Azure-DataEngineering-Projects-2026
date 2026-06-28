```markdown
# 🚀 Insurance Data Engineering Pipeline
### End-to-End Data Engineering Project using PostgreSQL, Apache Airflow, Snowflake, dbt & Power BI

<p align="center">
  <img src="https://github.com/vivekvkt/Azure-DataEngineering-Projects-2026/blob/main/Insurance_project_with_airflow_dbt_snowflake_postgresql/architecture/flow.png" width="900">
</p>

---

# 📌 Project Overview

This project demonstrates a modern **Data Engineering pipeline** that automates data ingestion, transformation, testing, and reporting using industry-standard tools.

The pipeline extracts insurance data from **PostgreSQL**, orchestrates workflows with **Apache Airflow**, loads raw data into **Snowflake Bronze**, transforms it into **Silver** and **Gold** layers using **dbt**, validates data quality through **dbt tests**, and finally visualizes business insights in **Power BI**.

This project follows the **Medallion Architecture (Bronze → Silver → Gold)**.

---

# 🏗️ Architecture

```

```
            PostgreSQL
                 │
                 ▼
          Apache Airflow
                 │
                 ▼
       Snowflake Bronze Layer
                 │
                 ▼
             dbt run
                 │
      ┌──────────┴──────────┐
      ▼                     ▼
  Silver Models        Gold Models
                 │
                 ▼
             dbt test
                 │
                 ▼
             Power BI
```

```

---

# 🔄 Pipeline Workflow

### Step 1
Data is stored inside **PostgreSQL**.

↓

### Step 2
Apache Airflow schedules and orchestrates the pipeline.

↓

### Step 3
Raw data is loaded into the **Snowflake Bronze Layer**.

↓

### Step 4
dbt transforms raw data into cleaned **Silver Models**.

↓

### Step 5
Business-ready **Gold Models** are generated.

↓

### Step 6
dbt executes automated data quality tests.

↓

### Step 7
Power BI connects to Gold models for reporting and dashboards.

---

# 🛠️ Technology Stack

| Tool | Purpose |
|------|----------|
| PostgreSQL | Source Database |
| Apache Airflow | Workflow Orchestration |
| Snowflake | Cloud Data Warehouse |
| dbt | Data Transformation |
| Docker | Containerization |
| Python | ETL Development |
| SQL | Data Transformation |
| Power BI | Dashboard & Reporting |

---

# 📂 Project Structure

```

Insurance_project_with_airflow_dbt_snowflake_postgresql/
│
├── airflow/
│   ├── dags/
│   ├── plugins/
│   └── docker-compose.yml
│
├── dbt/
│   ├── models/
│   │     ├── bronze/
│   │     ├── silver/
│   │     └── gold/
│   ├── tests/
│   └── dbt_project.yml
│
├── architecture/
│   └── flow.png
│
├── powerbi/
│
├── sql/
│
└── README.md

````

---

# ⚙️ Setup

## Clone Repository

```bash
git clone https://github.com/vivekvkt/Azure-DataEngineering-Projects-2026.git

cd Insurance_project_with_airflow_dbt_snowflake_postgresql
````

---

# 🐳 Start Airflow

```bash
docker compose up -d
```

Verify running containers:

```bash
docker ps
```

---

# 📦 Install dbt Inside Airflow Containers

Since dbt is executed from Airflow tasks, install **dbt-core** and **dbt-snowflake** inside both Scheduler and Worker containers.

---

## Scheduler Container

Open the scheduler container:

```bash
docker exec -it airflow-docker-airflow-scheduler-1 bash
```

Install dbt:

```bash
pip install dbt-core dbt-snowflake
```

Verify installation:

```bash
dbt --version
```

---

## Worker Container

Open another terminal.

Enter the worker container:

```bash
docker exec -it airflow-docker-airflow-worker-1 bash
```

Install dbt:

```bash
pip install dbt-core dbt-snowflake
```

Verify installation:

```bash
dbt --version
```

---

# ▶️ Running dbt

## Check Connection

```bash
dbt debug
```

---

## Execute Models

```bash
dbt run
```

---

## Run Data Quality Tests

```bash
dbt test
```

---

## Generate Documentation

```bash
dbt docs generate
```

---

## Serve Documentation

```bash
dbt docs serve
```

---

# 📊 Medallion Architecture

## 🥉 Bronze Layer

* Raw data from PostgreSQL
* No business transformations
* Historical data preserved

---

## 🥈 Silver Layer

* Data cleaning
* Data standardization
* Remove duplicates
* Apply business rules

---

## 🥇 Gold Layer

* Business-ready datasets
* Reporting tables
* KPI calculations
* Analytics models

---

# ✅ Data Quality Checks

The project validates data quality using **dbt tests**, including:

* Not Null Tests
* Unique Tests
* Relationship Tests
* Accepted Values
* Custom Business Rules

---

# 📈 Power BI Dashboard

Power BI connects directly to the **Gold Layer** in Snowflake to build:

* Executive Dashboard
* KPI Dashboard
* Sales Analysis
* Insurance Analytics
* Customer Insights

---

# 🚀 Key Features

* End-to-End Data Pipeline
* Automated Workflow using Airflow
* Snowflake Data Warehouse
* Medallion Architecture
* dbt Transformations
* Automated Data Testing
* Documentation Generation
* Power BI Reporting
* Dockerized Environment
* Modular & Scalable Design

---

# 📚 Useful dbt Commands

| Command             | Description                                 |
| ------------------- | ------------------------------------------- |
| `dbt debug`         | Verify project configuration and connection |
| `dbt run`           | Execute all dbt models                      |
| `dbt test`          | Run data quality tests                      |
| `dbt docs generate` | Generate project documentation              |
| `dbt docs serve`    | Launch dbt documentation locally            |

---

# 🎯 Future Enhancements

* CI/CD with GitHub Actions
* Incremental dbt Models
* Data Freshness Tests
* Airflow Notifications (Email/Slack)
* Great Expectations Integration
* Power BI Deployment Pipeline
* Unit Testing for ETL
* Data Lineage & Metadata

---

# 👨‍💻 Author

**Vivek Tiwari**

Python Data Engineer | Azure Data Engineer

**Skills**

* Python
* SQL
* Apache Airflow
* dbt
* Snowflake
* PostgreSQL
* Azure Data Factory
* Azure Databricks
* Azure Synapse Analytics
* Docker
* Power BI

---

⭐ If you found this project useful, don't forget to **Star** the repository!

```
```
