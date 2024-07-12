terraform {
  extra_arguments "plan_out" {
    commands  = ["plan"]
    arguments = ["-out", "tfplan"]
  }
  after_hook "after_hook" {
    commands = ["plan"]
    execute  = ["sh", "-c", "terraform show -json tfplan > plan.json"]
  }
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  common_tags = local.common_vars.locals.tags

  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment_tags = local.environment_vars.locals.tags
  environment_name = local.environment_vars.locals.environment
  account_id       = local.environment_vars.locals.account_id

  region_vars        = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region_tags        = local.region_vars.locals.tags
  region_name        = local.region_vars.locals.region_name
  tf_provider_region = local.region_vars.locals.tf_provider_region
  tf_state_bucket    = local.region_vars.locals.tf_state_bucket

  merged_tags = merge(local.common_tags, local.environment_tags, local.region_tags)
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.tf_provider_region}"
  default_tags {
    tags = ${jsonencode(local.merged_tags)}
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = local.tf_state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.tf_provider_region
    dynamodb_table = "nw-terraform-state-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  environment_name = local.environment_name
  account_id       = local.account_id
  region_name      = local.region_name
}
