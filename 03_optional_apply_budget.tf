# If the Apply Budget option is set to true, the default budget and alerting 
# are added to the new subscription

resource "azurerm_consumption_budget_subscription" "admin" {
  count = local.create_budgeet == true ? 1 : 0

  name            = "${azurerm_subscription.create.subscription_name}_budget"
  subscription_id = data.azurerm_subscription.current.id

  amount     = local.budget_limit
  time_grain = "Monthly"

  time_period {
    start_date = local.budget_start
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "EqualTo"

    contact_emails =  [ data.azuread_user.owner.user_principal_name ]

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled        = false
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_emails = [ data.azuread_user.owner.user_principal_name ]

  }

  depends_on = [ azurerm_subscription.create]


lifecycle {
    ignore_changes = [
      time_period
    ]
  }

}