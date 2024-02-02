AWS_PROFILE=personal aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com
AWS_PROFILE=personal docker build -t personal-analytics-dbt-staging .
AWS_PROFILE=personal docker tag personal-analytics-dbt-staging:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com/personal-analytics-dbt-staging:latest
AWS_PROFILE=personal docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com/personal-analytics-dbt-staging:latest