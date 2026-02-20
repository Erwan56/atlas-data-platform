provider "google" {
  project                     = var.project_id
  region                      = var.region
  impersonate_service_account = "tf-admin@atlas-data-platform.iam.gserviceaccount.com"
}

provider "google-beta" {
  project                     = var.project_id
  region                      = var.region
  impersonate_service_account = "tf-admin@atlas-data-platform.iam.gserviceaccount.com"
}
