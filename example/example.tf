locals {
    json_files = fileset(path.module, "subscription_configurations/*json")   
    json_data  = [ for f in local.json_files : jsondecode(file("${f}")) ]  
}

module "azurerm_ea_subscription" {
    source="../"

    for_each = { for f in local.json_data : f.owner => f }

    billing_account         = each.value.billing_account
    enrollment_account      = each.value.enrollment_account  

    owner                   = each.value.owner
    email                   = each.value.email
    purpose                 = each.value.purpose
    alias                   = each.value.alias

    # optional parameters
    apply_budget            = each.value.apply_budget
    management_group        = each.value.management_group

    create_service_principal = each.value.create_service_principal
    service_principal_display_name = each.value.service_principal_display_name
    
    create_automation_repo  = each.value.create_automation_repo
    github_username         = each.value.github_username
    template_repo_org       = each.value.template_repo_org
    template_repo           = each.value.template_repo
}

