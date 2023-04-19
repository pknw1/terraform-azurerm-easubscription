# If the option is set, we assign the subscription to the management group set
#

data "azurerm_management_group" "management" {
  count = var.management_group == "" ? 0 : 1

  name = var.management_group
}


resource "azurerm_management_group_subscription_association" "management" {
  count = var.management_group == "" ? 0 : 1

  management_group_id = data.azurerm_management_group.management[0].id
  subscription_id     = azurerm_subscription.create.id
}