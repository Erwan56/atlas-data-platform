# Email notification channels (Cloud Monitoring)
resource "google_monitoring_notification_channel" "budget_email" {
  for_each     = toset(var.alert_emails)
  display_name = "Budget email: ${each.value}"
  type         = "email"

  labels = {
    email_address = each.value
  }
}

# Monthly budget scoped to this project
resource "google_billing_budget" "monthly" {
  billing_account = var.billing_account_id
  display_name    = "Budget ${var.project_id} (${var.env})"

  amount {
    specified_amount {
      currency_code = "EUR"
      units         = tostring(var.monthly_budget_eur)
    }
  }

  budget_filter {
    projects = ["projects/${var.project_id}"]
  }

  threshold_rules { threshold_percent = 0.5 }
  threshold_rules { threshold_percent = 0.8 }
  threshold_rules { threshold_percent = 1.0 }

  all_updates_rule {
    # keep billing admins notified too (optional)
    disable_default_iam_recipients = false

    monitoring_notification_channels = [
      for ch in google_monitoring_notification_channel.budget_email : ch.name
    ]
  }
}
