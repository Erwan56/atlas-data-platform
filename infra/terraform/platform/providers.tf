provider "google" {
  project                     = var.project_id
  impersonate_service_account = var.terraform_admin_sa
}

provider "google-beta" {
  project                     = var.project_id
  impersonate_service_account = var.terraform_admin_sa
}
