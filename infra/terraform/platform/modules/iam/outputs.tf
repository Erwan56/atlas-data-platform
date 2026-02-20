output "airbyte_sa_email" {
  value = google_service_account.airbyte.email
}

output "dbt_sa_email" {
  value = google_service_account.dbt.email
}
