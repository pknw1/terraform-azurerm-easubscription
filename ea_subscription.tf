resource "azurerm_subscription" "create" {
  
  subscription_name = local.subscription_display_name
  billing_scope_id  =  data.azurerm_billing_enrollment_account_scope.billing_account.id

lifecycle {
    ignore_changes = [
      tags, alias
    ]
  }

}


resource "azurerm_role_assignment" "subscriptiption" {
  count = data.azurerm_client_config.current.object_id != data.azuread_user.owner.object_id ? 1 : 0 
  
  scope                = azurerm_subscription.create.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.owner.object_id

  depends_on = [ azurerm_subscription.create, ]
}



