variable "service_accounts" {
  description = "List of service accounts to manage."
  type        = list(object({
    name         = string
    display_name = string
    roles        = list(string)
    members      = list(string)
  }))
}

resource "google_service_account" "managed" {
  for_each    = { for sa in var.service_accounts : sa.name => sa }
  account_id  = each.value.name
  display_name = each.value.display_name
}

resource "google_service_account_iam_member" "managed" {
  for_each = {
    for sa in var.service_accounts : sa.name => sa
  }
  count   = length(each.value.roles) * length(each.value.members)
  service_account_id = google_service_account.managed[each.key].name
  role               = each.value.roles[count.index / length(each.value.members)]
  member             = each.value.members[count.index % length(each.value.members)]
}
