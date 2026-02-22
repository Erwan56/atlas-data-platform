
output "raw_bucket" { value = module.gcs.raw_bucket_name }
output "dbt_sa" { value = module.iam.dbt_sa_email }
output "ci_sa" { value = module.iam.ci_sa_email }
