# GCP is the primary target — configure project/region via variables (and credentials in TFC).

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

# Lightweight AWS sample for multi-cloud cost plans (mock creds are enough for many plan-only runs).

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}
