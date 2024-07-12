locals {
  environment = basename(get_terragrunt_dir())
  account_id  = get_aws_account_id()
  tags = {
    environment = local.environment
  }
}
