variable "budget_email" {} # Should be defined as TF_VAR_budget_email env variable see README.md for more details

resource "aws_budgets_budget" "daily_budget" {
  name         = "DailySpendingLimit"
  budget_type  = "COST"
  time_unit    = "DAILY"
  limit_amount = "5"
  limit_unit   = "USD"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.budget_email]
  }
}
