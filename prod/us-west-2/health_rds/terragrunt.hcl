terraform {
  source = "../../..//_common_modules/rds"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  project_name            = "health"
  department              = "ladvien-analytics"
  subnet_name             = "public"
  engine                  = "postgres"
  engine_version          = "14.1"
  family                  = "postgres14"

  instance_class          = "db.t4g.micro"
  allocated_storage       = "5"
  max_allocated_storage   = "20"

  db_name                 = "health"
  username                = "health" // Cannot use "admin", as it is reserved.
  port                    = 5432
  
  monitoring_interval     = "0"
  create_monitoring_role  = false
  multi_az                = false
  backup_retention_period = "2"

  publicly_accessible     = true
  apply_immediately       = true 
  
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  db_parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  vpc_id                      = dependency.vpc.outputs.vpc_id
  vpc_cidr_block              = dependency.vpc.outputs.vpc_cidr_block
}
