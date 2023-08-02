# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # source = "git@gitlab.com:ladvien/dev-ops/aws/terraform-modules.git//efs?ref=efs-v0.0.3"
  source = "../../../../../../_common_modules//dbt"
}


# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
    project_name            = "clarity-analytics-dbt"
    department              = "data_services"

    # Key to used for encryption of all resources.
    kms_alias                           = "alias/staging-clarity-analytics-key"

    # Resources to allocate for Dbt task.
    cpus                    = 512
    memory                  = 1024

    efs_id                  = "fs-<ID>"
    efs_security_group_id   = "sg-<ID>"
    s3_code_bucket_name     = "persona-code-bucket"
    kms_for_s3_bucket_arn   = "<BUCKET_KMS_ARN>"

    vpc_cidr                = "<CIDR_BLOCK>" 

    instance_name = "data-sandbox"
}
