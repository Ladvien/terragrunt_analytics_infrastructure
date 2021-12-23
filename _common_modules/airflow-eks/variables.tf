
variable "region" {
  default = ""
}

variable "env" {}

variable "namespace" {
  type    = string
  default = "airflow"
}
variable "chart_version" {
  type    = string
  default = "6.9.1"
}
variable "airflow_image_tag" {}
variable "dags_git_repo_url" {}
variable "dags_git_repo_branch" {}

variable "fernet_key" {}
variable "airflow_dns_name" {}
variable "ingress_class" {}

variable "postgres_db_name" {}
variable "postgres_db_host" {}
variable "postgres_db_username" {}

variable "irsa_assumable_role_arn" {}

variable "google_oauth_client_id" {}
variable "google_oauth_client_secret" {}

variable "vpc_id" {}

variable "subnets" {}

variable "project_name" {}
