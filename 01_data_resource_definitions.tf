data "azurerm_billing_enrollment_account_scope" "billing_account" {
  billing_account_name    = var.billing_account
  enrollment_account_name = var.enrollment_account
}

data "azurerm_subscription" "current" { }
data "azurerm_client_config" "current" { }
data "azuread_user" "owner" {
  user_principal_name = var.email
}
