
resource "google_storage_bucket" "raw" {
  project                     = var.project_id
  name                        = "atlas-raw-${var.env}"
  location                    = var.location
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true

  versioning { enabled = true }

  lifecycle_rule {
    condition { age = 30 }
    action { type = "Delete" }
  }
}
