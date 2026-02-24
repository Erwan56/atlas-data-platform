variable "impersonate_sa" {
  type    = string
  default = "" # empty = no impersonation
}

provider "google" {
  project                     = var.project_id
  impersonate_service_account = var.impersonate_sa != "" ? var.impersonate_sa : null
  default_labels = {
    env = var.env
  }
}

provider "google-beta" {
  project                     = var.project_id
  impersonate_service_account = var.impersonate_sa != "" ? var.impersonate_sa : null
  default_labels = {
    env = var.env
  }
}
