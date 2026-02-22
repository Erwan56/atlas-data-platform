variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "europe-west1"
}
variable "env" { type = string }

variable "terraform_admin_sa" { type = string } # tf-admin@...
