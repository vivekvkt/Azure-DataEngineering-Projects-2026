<p align="center">
  <img src="https://github.com/vivekvkt/Azure-DataEngineering-Projects-2026/blob/main/Insurance_project_with_airflow_dbt_snowflake_postgresql/architecture/flow.png" width="900">
</p>


Q1. Explain your Insurance Claims Analytics Project.

Answer:

I built an end-to-end Insurance Claims Analytics platform using a Medallion Architecture.

The project starts with PostgreSQL as the operational database where insurance data such as customers, agents, policies, and claims is stored.

I used Apache Airflow to orchestrate the ETL pipeline. Airflow extracts data from PostgreSQL, performs validation and transformation using Python, and loads the raw data into the Bronze layer of Snowflake.

Inside Snowflake, I implemented a Medallion Architecture consisting of Bronze, Silver, and Gold layers.

Using dbt, I transformed Bronze tables into business-ready Silver models and analytical Gold models.

Finally, Power BI connects to the Gold models to create executive dashboards showing KPIs, claim trends, fraud analytics, and agent performance.

Everything runs inside Docker containers, making the environment portable and reproducible.

Docker
Q2. Why did you use Docker?

Answer

Docker solves the "works on my machine" problem.

Instead of installing Airflow, PostgreSQL, Redis, and dependencies manually, Docker packages everything into containers.

Benefits:

Consistent environment
Easy deployment
Isolation
Portability
Faster setup
Q3. Which containers did you use?
Airflow Webserver
Airflow Scheduler
Airflow Worker
PostgreSQL
Redis
Q4. Why Redis?

Redis acts as the message broker for CeleryExecutor.

It stores task queues between:

Worker ↔ Scheduler

Without Redis, distributed task execution isn't possible.

Q5. Why PostgreSQL?

Two reasons:

Source Database

Stores insurance transactional data.

Airflow Metadata Database

Stores:

DAG Runs
Task Instances
Scheduler state
Users
Connections
Apache Airflow
Q6. Why Airflow?

Airflow automates ETL pipelines.

Instead of running Python scripts manually, Airflow schedules and monitors workflows.

Q7. Why not use Cron Jobs?

Cron can only execute scripts.

Airflow provides:

DAG dependency management
Retry mechanism
Monitoring
Logging
Alerts
Scheduling
Parallel execution
Q8. What is a DAG?

DAG stands for Directed Acyclic Graph.

It represents task dependencies.

Example:

Extract Customers
      ↓
Load Customers
      ↓
Validation
      ↓
Notification
Q9. Which operators did you use?

Mainly:

PythonOperator

Because all extraction, loading, and validation logic was written in Python.

Q10. How does Scheduler work?

Scheduler continuously checks DAGs.

If execution time matches schedule:

Scheduler

↓

Creates DAG Run

↓

Creates Task Instances

↓

Worker executes tasks

Q11. What does Worker do?

Worker executes the actual task.

Example:

extract_customers()

runs inside Worker.

Q12. Why Scheduler and Worker are separate?

Scheduler only plans work.

Worker performs work.

This separation improves scalability.

Python
Q13. Why Python?

Python was used for:

PostgreSQL connection
Data extraction
Pandas transformations
Date conversion
Snowflake loading
Data validation
Q14. Which libraries?
pandas
psycopg2
snowflake-connector-python
write_pandas
airflow
Q15. Why Pandas?

Pandas makes:

Cleaning
Filtering
Transformation
Null handling

easy before loading into Snowflake.

Snowflake
Q16. Why Snowflake?

Snowflake is a cloud-native Data Warehouse.

Advantages:

Separate compute and storage
Auto scaling
Auto suspend
High performance
Zero maintenance
Q17. Why Medallion Architecture?

Because raw data shouldn't be directly consumed.

Pipeline:

Bronze

↓

Silver

↓

Gold

Q18. Explain Bronze Layer.

Raw data.

Exactly as extracted.

No transformations.

Q19. Explain Silver Layer.

Business transformations.

Examples:

Full Name
Age
Tenure
Processing Time
Standardized columns
Q20. Explain Gold Layer.

Business-ready models.

Examples:

Claim Summary
Revenue KPIs
Fraud Analytics
Agent Performance
Q21. Why separate Bronze/Silver/Gold?

Advantages:

Better governance
Easier debugging
Reusable models
Layered architecture
dbt
Q22. Why dbt?

dbt performs SQL-based transformations inside Snowflake.

Instead of Python transformations,

Transformation happens inside Snowflake.

Q23. Why not transform inside Airflow?

Airflow is an orchestrator.

dbt is a transformation tool.

Responsibilities remain separate.

Q24. What are dbt Sources?

Sources define raw tables.

Example:

sources:
  - name: bronze
Q25. What are Models?

Models are SQL files.

Each SQL file creates a table or view.

Q26. Difference between Source and Model?

Source

↓

Existing Table

Model

↓

Generated Table

Q27. What are Tests?

Tests validate data quality.

Examples:

Unique

Not Null

Accepted Values

Relationships

Q28. Which dbt commands did you use?
dbt debug

dbt parse

dbt ls

dbt run

dbt test

dbt docs generate
Power BI
Q29. Why Power BI?

Business users need dashboards instead of SQL queries.

Power BI provides:

KPIs
Charts
Drilldowns
Filters
Interactive reports
Q30. Which dashboards?

Executive Dashboard

Claim Summary

Fraud Analytics

Agent Performance

Data Quality
Q31. How did you validate data?

Airflow validation task.

Checked:

Record counts
Nulls
Successful loads

dbt Tests:

unique
not_null
Project Flow
Q32. Explain the complete flow.
PostgreSQL

↓

Airflow Extract

↓

Python Transformation

↓

Snowflake Bronze

↓

dbt Silver

↓

dbt Gold

↓

Power BI
Real-Time Scenario
Q33. Suppose a new Claims table is introduced. What changes are needed?
Create PostgreSQL table.
Create Airflow extraction task.
Load into Bronze.
Add dbt Source.
Create Silver model.
Create Gold model.
Update Power BI dashboard.
Why Each Technology?
Technology	Why Used	Role in Project
Docker	Containerization	Runs all services consistently
PostgreSQL	Source OLTP database	Stores operational insurance data
Airflow	Workflow orchestration	Schedules and manages ETL pipelines
Python	Data extraction and processing	Connects systems and performs transformations
Pandas	In-memory data manipulation	Cleans and prepares data before loading
Snowflake	Cloud Data Warehouse	Stores Bronze, Silver, and Gold layers
dbt	SQL transformation framework	Builds analytical models inside Snowflake
SQL	Data transformation language	Queries and transforms warehouse data
Power BI	Business Intelligence	Creates dashboards and reports
Git	Version control	Tracks project changes and collaboration
GitHub	Code repository	Hosts project and portfolio
Docker Compose	Multi-container management	Starts Airflow, PostgreSQL, Redis, and supporting services together
Interview Readiness

This project covers the core skills expected in modern Data Engineering roles:

✅ Python
✅ SQL
✅ PostgreSQL
✅ Docker
✅ Apache Airflow
✅ Snowflake
✅ dbt
✅ Data Warehousing
✅ Medallion Architecture
✅ ETL/ELT
✅ Power BI
✅ Git & GitHub