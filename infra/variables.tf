variable "gcp_project" {
  description = "GCP project ID (set in Terraform Cloud as a workspace variable)."
  type        = string
  default     = "test"
}

variable "gcp_region" {
  description = "Default GCP region for regional resources."
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone for the demo Compute instance."
  type        = string
  default     = "us-central1-a"
}

variable "enable_azure" {
  description = "When true, creates a minimal Azure resource group (requires ARM_* credentials in TFC)."
  type        = bool
  default     = false
}
