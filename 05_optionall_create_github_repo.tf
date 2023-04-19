# if the option is set, we create a github repository in which the subsription owner can maintain the 
# code for this repository

resource "github_repository" "repo" {

  count = var.create_automation_repo == true ? 1 : 0 

  name        = local.repository_name
  description = "Automation repository for ${azurerm_subscription.create.id}"

  visibility = "private"
  auto_init = true

  template {
    owner                = var.template_repo_org
    repository           = var.template_repo
  }
}

resource "github_repository_collaborator" "add_maintainer" {

  count = var.create_automation_repo == true ? 1 : 0 

  repository = local.repository_name
  username = var.github_username
  permission     = "admin"
}