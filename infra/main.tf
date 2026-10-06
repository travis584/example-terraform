# Root module for a single Terraform Cloud workspace (working directory: infra).
# Child folders hold per-cloud resources; providers are configured above.

module "aws" {
  source = "./aws"
}

module "azure" {
  source = "./azure"
}

module "google" {
  source = "./google"
}
