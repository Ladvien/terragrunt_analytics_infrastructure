#!/bin/bash
# Invoked in container. Will run in ECS Fargate. Called by Orchestration Tool (i.e. Airflow)
set -e

echo "Present working directory:"
pwd 
echo "Pulling latest Dbt models from S3"
aws s3 cp s3://stage-csv-etl/ .\
                    --recursive \
                    --exclude '*' \
                    --include 'personal-analytics-dbt/*'

# We use this to securely import our Redshift credentials on runtime for the dbt profile
# echo "Running .py script to get glue connection redshift credentials"
# python3 ./scripts/export_glue_redshift_connection.py # writes .redshift_credentials file

# echo "Exporting Redshift credentials as environment variables to be used by dbt"
# . ./.redshift_credentials

echo "Running dbt:"
dbt deps --profiles-dir ./dbt --project-dir ./personal-analytics-dbt
# echo ""
# dbt debug --profiles-dir ./dbt --project-dir ./dbt
# echo ""
# dbt run --profiles-dir ./dbt --project-dir ./dbt
# echo ""
# dbt test --profiles-dir ./dbt --project-dir ./dbt
# echo ""
# dbt source freshness --profiles-dir ./dbt --project-dir ./dbt
# dbt docs generate --profiles-dir ./dbt --project-dir ./dbt
# echo ""

# dbt --version

# ls -la