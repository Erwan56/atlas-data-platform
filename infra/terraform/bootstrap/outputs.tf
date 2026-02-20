output "tf_admin_email" {
  value = google_service_account.tf_admin.email
}

output "wif_provider_resource_name" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "tfstate_bucket" {
  value = google_storage_bucket.tfstate.name
}
