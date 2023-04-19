# if the option to vcreate an automation service principal is set, we create the app 

resource "azuread_application" "sp" {
  count = var.create_service_principal == true ? 1 : 0

  display_name = local.service_principal_display_name
  owners       = [data.azuread_user.owner.object_id]
}

resource "azuread_service_principal" "sp" {
  count = var.create_service_principal == true ? 1 : 0

  application_id               = azuread_application.sp[0].application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_user.owner.object_id]
}