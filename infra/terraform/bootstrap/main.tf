# 1) Bucket remote state
resource "google_storage_bucket" "tfstate" {
  name                        = var.state_bucket_name
  location                    = "EU"
  uniform_bucket_level_access = true
  versioning { enabled = true }

  lifecycle_rule {
    condition { num_newer_versions = 20 }
    action { type = "Delete" }
  }
}

# Reco sécurité: empêcher la suppression accidentelle
resource "google_storage_bucket_iam_member" "tfstate_viewer_project" {
  bucket = google_storage_bucket.tfstate.name
  role   = "roles/storage.objectViewer"
  member = "projectOwner:${var.project_id}"
}

# 2) Service account Terraform
resource "google_service_account" "tf_admin" {
  account_id   = "tf-admin"
  display_name = "Terraform Admin"
}

# 3) Rôles nécessaires à Terraform (à affiner ensuite)
locals {
  tf_roles = toset([
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
    "roles/bigquery.admin",
    "roles/secretmanager.admin",
  ])
}

resource "google_project_iam_member" "tf_admin_roles" {
  for_each = local.tf_roles
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.tf_admin.email}"
}

# 4) Workload Identity Federation (GitHub Actions OIDC)
# Pool
resource "google_iam_workload_identity_pool" "github" {
  provider                  = google-beta
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
}

# Provider
resource "google_iam_workload_identity_pool_provider" "github" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub OIDC Provider"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }

  attribute_condition = "attribute.repository == \"${var.github_owner}/${var.github_repo}\""
}

# Autoriser GitHub à "devenir" tf-admin (principalSet + repo + ref)
resource "google_service_account_iam_member" "tf_admin_wif" {
  service_account_id = google_service_account.tf_admin.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
}

# Autoriser GitHub à signer des tokens pour l'impersonation (souvent nécessaire)
resource "google_service_account_iam_member" "tf_admin_token_creator" {
  service_account_id = google_service_account.tf_admin.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
}

resource "google_project_iam_member" "tf_admin_bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:tf-admin@${var.project_id}.iam.gserviceaccount.com"
}
