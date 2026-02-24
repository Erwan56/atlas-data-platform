module "gcs" {
  source        = "./modules/gcs"
  project_id    = var.project_id
  env           = var.env
  location      = "EU"
  force_destroy = true
}

module "bq" {
  source      = "./modules/bq"
  project_id  = var.project_id
  bq_location = var.bq_location
}

module "iam" {
  source          = "./modules/iam"
  project_id      = var.project_id
  env             = var.env
  bq_datasets     = var.bq_datasets
  raw_bucket_name = module.gcs.raw_bucket_name
  depends_on      = [module.bq]
}

module "billing" {
  source             = "./modules/billing"
  billing_account_id = var.billing_account_id
  project_id         = var.project_id
  env                = var.env
  monthly_budget_eur = var.monthly_budget_eur
  alert_emails       = var.alert_emails
}
