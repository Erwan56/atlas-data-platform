
resource "google_service_account" "dbt" {
  project      = var.project_id
  account_id   = "sa-atlas-dbt-${var.env}"
  display_name = "Atlas DBT (${var.env})"
}

resource "google_service_account" "ci" {
  project      = var.project_id
  account_id   = "sa-atlas-ci-${var.env}"
  display_name = "Atlas CI (${var.env})"
}

# --- BigQuery permissions ---

# RAW: dbt en lecture
resource "google_bigquery_dataset_iam_member" "dbt_raw_viewer" {
  project    = var.project_id
  dataset_id = var.bq_datasets.raw
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${google_service_account.dbt.email}"
}

# STAGING + MART: dbt en écriture
resource "google_bigquery_dataset_iam_member" "dbt_staging_editor" {
  project    = var.project_id
  dataset_id = var.bq_datasets.staging
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt.email}"
}

resource "google_bigquery_dataset_iam_member" "dbt_mart_editor" {
  project    = var.project_id
  dataset_id = var.bq_datasets.mart
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt.email}"
}

# dbt doit lancer des jobs (requêtes)
resource "google_project_iam_member" "dbt_jobuser" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt.email}"
}

# CI: typiquement jobUser + viewer (à ajuster selon usage futur)
resource "google_project_iam_member" "ci_jobuser" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.ci.email}"
}

resource "google_project_iam_member" "ci_bq_viewer" {
  project = var.project_id
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:${google_service_account.ci.email}"
}

# --- Optional: droits GCS raw bucket ---
resource "google_storage_bucket_iam_member" "dbt_bucket_reader" {
  count  = var.raw_bucket_name == null ? 0 : 1
  bucket = var.raw_bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.dbt.email}"
}

resource "google_storage_bucket_iam_member" "ci_bucket_reader" {
  count  = var.raw_bucket_name == null ? 0 : 1
  bucket = var.raw_bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.ci.email}"
}
