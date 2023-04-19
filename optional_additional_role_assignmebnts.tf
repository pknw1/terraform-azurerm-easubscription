
resource "azurerm_role_assignment" "owner_assignments" {
  count = var.owner_assignments != [] ? length(var.owner_assignments) : 0

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.owner_assignments[count.index].id

}

resource "azurerm_role_assignment" "contributor_assignments" {
  count = var.contributor_assignments != [] ? length(var.contributor_assignments) : 0

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_user.contributor_assignments[count.index].id

}

resource "azurerm_role_assignment" "reader_assignments" {
  count = var.reader_assignments != [] ? length(var.reader_assignments) : 0

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_user.reader_assignments[count.index].id
  
}