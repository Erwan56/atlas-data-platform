variable "project_id" { type = string }

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "env" { type = string }               # dev / prod
variable "state_bucket_name" { type = string } # ex: atlas-tfstate-dev

# GitHub repo pour OIDC
variable "github_owner" { type = string } # ex: ton user/org GitHub
variable "github_repo" { type = string }  # ex: atlas-data-platform

# Optionnel: branch protégée
variable "github_ref" {
  type    = string
  default = "refs/heads/main"
}
