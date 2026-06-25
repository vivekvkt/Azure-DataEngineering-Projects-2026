Run Flow
PostgreSQL
      ↓
Airflow
      ↓
Snowflake Bronze
      ↓
dbt run
      ↓
Silver Models
      ↓
Gold Models
      ↓
dbt test
      ↓
Power BI
Commands
dbt debug
dbt run
dbt test
dbt docs generate
dbt docs serve


Install dbt directly inside all Airflow containers.

Scheduler
docker exec -it airflow-docker-airflow-scheduler-1 bash

Inside:

pip install dbt-core dbt-snowflake

Wait until installation completes.

Verify:

dbt --version
Worker

Open another terminal:

docker exec -it airflow-docker-airflow-worker-1 bash

Install:

pip install dbt-core dbt-snowflake

Verify:

dbt --version