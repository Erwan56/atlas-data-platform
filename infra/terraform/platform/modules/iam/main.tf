resource "google_service_account" "airbyte" {
  account_id   = "sa-airbyte-${var.env}"
  display_name = "Airbyte (${var.env})"
}

resource "google_service_account" "dbt" {
  account_id   = "sa-dbt-${var.env}"
  display_name = "dbt (${var.env})"
}

resource "google_project_iam_member" "dbt_jobuser" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt.email}"
}
