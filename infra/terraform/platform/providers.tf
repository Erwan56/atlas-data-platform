provider "google-beta" {
  project                     = var.project_id
  region                      = var.region
  impersonate_service_account = var.terraform_admin_sa
}
