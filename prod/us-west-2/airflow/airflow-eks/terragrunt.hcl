terraform {
  source = "../../../..//_common_modules/airflow-eks"
}

locals {
  helm_values = yamldecode(file("helm_values.yml"))
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
    subnets                    = dependency.vpc.outputs.vpc_private_subnets
    vpc_id                     = dependency.vpc.outputs.vpc_id
    namespace                  = "airflow"
    airflow_dns_name           = "airflow.maddatum.com"
    # cluster_id                 = module.airflow-eks.cluster_id
    postgres_db_host           = "my-database.host.com"
    postgres_db_name           = "airflow"
    postgres_db_username       = "airflow"
    # irsa_assumable_role_arn    = module.iam_assumable_role_airflow.this_iam_role_arn
    airflow_image_tag          = "1.10.10"

    ingress_class              = "nginx"
    dags_git_repo_url          = "git@github.com:mycompany/dags.git"
    dags_git_repo_branch       = "master"
    chart_version              = "6.9.1"
    google_oauth_client_id     = "XXXXX.apps.googleusercontent.com"
    google_oauth_client_secret = "XXXXX"

    helm_values_file_path     = "/Users/ladvien/ladvien_terragrunt/prod/us-west-2/airflow/airflow-eks/helm_values.yml"
    helm_values                =  yamldecode(file("/Users/ladvien/ladvien_terragrunt/prod/us-west-2/airflow/airflow-eks/helm_values.yml"))
}
