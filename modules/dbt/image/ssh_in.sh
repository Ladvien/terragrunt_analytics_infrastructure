AWS_PROFILE=personal aws ecs execute-command --region us-west-2 \
                                                                --cluster personal-analytics-dbt \
                                                                --task arn:aws:ecs:us-west-2:<AWS_ACCOUNT_ID>:task/personal-analytics-dbt/6e407681e03b4858951f9052aa0040d5 \
                                                                --container personal-analytics-dbt \
                                                                --command "/bin/sh" \
                                                                --interactive