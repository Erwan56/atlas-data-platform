project_id = "atlas-data-platform"
env        = "dev"

bq_datasets = {
  raw     = "raw"
  staging = "staging"
  mart    = "mart"
}

# Billing variables
billing_account_id = "019317-DE8865-E96867"
monthly_budget_eur = 50
alert_emails       = ["erwan.allain@gmail.com"]
