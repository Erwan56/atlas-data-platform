
variable "project_id" { type = string }

variable "terraform_admin_sa" {
  description = "Service account used by Terraform via impersonation"
  type        = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}
variable "env" {
  description = "Environment name (dev, prod, etc)"
  type        = string
  default     = "dev"
}

variable "bq_location" {
  description = "BigQuery dataset location (e.g. EU, US)"
  type        = string
  default     = "EU"
}

variable "bq_datasets" {
  type = object({
    raw     = string
    staging = string
    mart    = string
  })
}
