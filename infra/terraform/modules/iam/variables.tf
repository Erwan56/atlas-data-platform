variable "service_accounts" {
  description = "List of service accounts to manage."
  type        = list(object({
    name         = string
    display_name = string
    roles        = list(string)
    members      = list(string)
  }))
}
