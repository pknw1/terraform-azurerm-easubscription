# If the option is set to enable an automation repository to be created and an automation service
# principal is selected, we will pre-populate the github secrets for running terraform in the repo

	
data "github_actions_public_key" "public_key" {
  count = var.create_automation_repo == true ? 1 : 0

  repository          = local.repository_name
  depends_on = [ azuread_application.sp,
                github_repository.repo ]
}

resource "github_actions_secret" "subscriptionid" {
  count = var.create_automation_repo == true ? 1 : 0

  repository       = local.repository_name
  secret_name      = "ARM_SUBSCRIPTION_ID"
  plaintext_value  = azurerm_subscription.create.id

    depends_on = [ data.github_actions_public_key.public_key ]
}

resource "github_actions_secret" "ARM_CLIENT_ID" {
  count = var.create_service_principal == true ? 1 : 0

  repository          = local.repository_name
  secret_name      = "ARM_CLIENT_ID"
  plaintext_value  = azuread_application.sp[0].application_id

    depends_on = [ data.github_actions_public_key.public_key,
                    azuread_application.sp ]
}


resource "azuread_service_principal_password" "sp" {
  count = var.create_service_principal == true ? 1 : 0

  service_principal_id = azuread_service_principal.sp[0].object_id
}

resource "github_actions_secret" "ARM_CLIENT_SECRET" {
  count = var.create_service_principal == true ? 1 : 0

  repository          = local.repository_name
  secret_name      = "ARM_CLIENT_SECRET"
  plaintext_value  = azuread_service_principal_password.sp[0].value

    depends_on = [ data.github_actions_public_key.public_key,
    azuread_application.sp ]


}




resource "github_actions_secret" "ARM_TENANT_ID" {

 #   for_each = { for key, value in local.images : key => value if create_repo == true }
 # for_each = local.images

  repository          = local.repository_name
  secret_name      = "ARM_TENANT_ID"
  plaintext_value  = data.azurerm_client_config.current.tenant_id

    depends_on = [ data.github_actions_public_key.public_key ]

}
