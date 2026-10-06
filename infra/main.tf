# Root module for a single Terraform Cloud workspace (working directory: infra).

# --- Google (primary) ---

resource "google_compute_instance" "poc" {
  name         = "tfc-poc-vm"
  machine_type = "e2-medium"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 50
    }
  }

  network_interface {
    network = "default"
  }

  labels = {
    environment = "poc"
    managed_by  = "terraform-cloud"
  }
}

# --- AWS (minimal second cloud) ---

resource "aws_s3_bucket" "poc_logs" {
  bucket = "example-terraform-tfc-poc-logs"

  tags = {
    Environment = "poc"
    ManagedBy   = "terraform-cloud"
  }
}

# --- Azure (optional; off by default so TFC does not need az CLI / ARM creds) ---

module "azure" {
  count  = var.enable_azure ? 1 : 0
  source = "./azure"

  location = "eastus"
  name     = "example-terraform-poc"
}
