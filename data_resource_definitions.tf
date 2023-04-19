data "azurerm_billing_enrollment_account_scope" "billing_account" {
  billing_account_name    = var.billing_account
  enrollment_account_name = var.enrollment_account
}

data "azurerm_subscription" "current" { }
data "azurerm_client_config" "current" { }
data "azuread_user" "owner" {
  user_principal_name = var.owner
}

data "azuread_user" "owner_assignments" {
  count = var.owner_assignments != [] ? length(var.owner_assignments) : 0
  user_principal_name = var.owner_assignments[count.index]
}

data "azuread_user" "contributor_assignments" {
  count = var.contributor_assignments != [] ? length(var.contributor_assignments) : 0
  user_principal_name = var.contributor_assignments[count.index]
}

data "azuread_user" "reader_assignments" {
  count = var.reader_assignments != [] ? length(var.reader_assignments) : 0
  user_principal_name = var.reader_assignments[count.index]
}
