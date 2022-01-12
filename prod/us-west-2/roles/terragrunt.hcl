terraform {
  source = "../../..//_common_modules/iam_admin_role"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    role_name = "airflow_admin_role"
}
