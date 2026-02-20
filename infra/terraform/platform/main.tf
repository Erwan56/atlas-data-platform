module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  env        = var.env
}

module "gcs" {
  source     = "./modules/gcs"
  project_id = var.project_id
  env        = var.env
}

module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  env        = var.env
}
