resource "google_bigquery_dataset" "raw" {
  dataset_id = "raw"
  project    = var.project_id
  location   = var.bq_location
}

resource "google_bigquery_dataset" "staging" {
  dataset_id = "staging"
  project    = var.project_id
  location   = var.bq_location
}

resource "google_bigquery_dataset" "mart" {
  dataset_id = "mart"
  project    = var.project_id
  location   = var.bq_location
}
