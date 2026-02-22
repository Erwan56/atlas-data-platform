variable "project_id" { type = string }
variable "env" { type = string }

variable "bq_datasets" {
  type = object({
    raw     = string
    staging = string
    mart    = string
  })
}

# optionnel: si tu veux aussi des droits sur GCS raw bucket
variable "raw_bucket_name" {
  type    = string
  default = null
}
