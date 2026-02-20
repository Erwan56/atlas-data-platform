terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project                     = var.project_id
  region                      = var.region
  impersonate_service_account = "tf-admin@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_service_account" "tf_admin" {
  account_id   = "tf-admin"
  display_name = "Terraform Admin Service Account"
}

resource "google_service_account_iam_member" "tf_admin_impersonate" {
  service_account_id = google_service_account.tf_admin.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:erwan.allain@gmail.com "
}

module "iam" {
  source = "./modules/iam"
  service_accounts = [
    {
      name         = "airbyte"
      display_name = "Airbyte Service Account"
      roles        = ["roles/editor"]
      members      = ["user:erwan.allain@gmail.com"]
    },
    {
      name         = "dbt"
      display_name = "dbt Service Account"
      roles        = ["roles/editor"]
      members      = ["user:erwan.allain@gmail.com"]
    }
  ]
}
