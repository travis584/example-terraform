provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

provider "azurerm" {
  # azurerm 5.x: skip_provider_registration was removed; "none" matches the old skip=true behavior.
  resource_provider_registrations = "none"
  features {}
}

provider "google" {
  region  = "us-central1"
  project = "test"
}
