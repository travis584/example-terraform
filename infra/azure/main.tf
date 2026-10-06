# Auth: set ARM_SUBSCRIPTION_ID, ARM_TENANT_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET in TFC (no Azure CLI).

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
  use_cli                         = false
  use_msi                         = false
}

resource "azurerm_resource_group" "poc" {
  name     = var.name
  location = var.location

  tags = {
    Environment = "poc"
    ManagedBy   = "terraform-cloud"
  }
}
