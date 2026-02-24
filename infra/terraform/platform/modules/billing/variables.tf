variable "billing_account_id" {
  type        = string
  description = "Billing account id like XXXXXX-XXXXXX-XXXXXX"
}

variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "monthly_budget_eur" {
  type    = number
  default = 50
}

variable "alert_emails" {
  type    = list(string)
  default = []
}
