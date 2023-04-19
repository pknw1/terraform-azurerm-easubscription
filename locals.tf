locals {


    owner     = var.owner != "" ? var.owner : data.azurerm_client_config.current.object_id
    purpose   = var.purpose != "" ? var.purpose : "Dev/Test Subscription"
    email     = var.email != "" ? var.email : local.owner 
    alias     = var.alias != "" ? var.alias : "static"

    agreement_type      = "ea"
    billing_account     = var.billing_account != "" ?  var.billing_account : "87561154"
    enrollment_account  = var.enrollment_account != "" ? var.enrollment_account : "311200"

    associate_management_group = true
    management_group_name = var.management_group != "" ? var.management_group : "UK"

    create_service_principal          = true
    service_principal_display_name    = var.service_principal_display_name != "" ? var.service_principal_display_name : data.azurerm_subscription.current.id    

    owners_merged                   = concat( [local.owner], [local.owner_assignments])
 
    create_budgeet = var.apply_budget 
    create_shared_remote_backend = true

    backend_container_name = lower(replace("${local.alias}state", "_", "-"))
    subscription_display_name = join(" ", [local.alias, local.purpose])
    subscription_alias = join(" ", [local.alias, local.owner])

    template_repo_org = var.template_repo_org != "" ? var.template_repo_org : "pknw1"
    template_repo     = var.template_repo     != "" ? var.template_repo     : "terraform-boilerplate"

    template_repo_name = "terraform-boilerplate"

    budget_limit = "60"
    budget_month = formatdate("YYYY-MM", timestamp()) 
    budget_start = join("-", [local.budget_month, "01T00:00:00Z"])
    budget_emails = jsonencode([ "${var.email}", ])
    tags = {
      "owner" = "${var.owner}"
      "email" = "${var.email}"
      "created" = "${timestamp()}"
    }

    repository_name="${join("_", ["${local.alias}", "automation_repositoty"])}"

    owner_assignments = var.owner_assignments == [] ? "no additional users" : jsonencode(var.owner_assignments)
    contributor_assignments = var.contributor_assignments == [] ? "no additional users" : jsonencode(var.contributor_assignments)
    reader_assignments = var.reader_assignments == [] ? "no additional users" : jsonencode(var.reader_assignments)

}
