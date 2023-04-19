/*variable "owner" { default = "paul.kelleher@contino.io" }
variable "purpose" { default = "test" }
variable "email" { default = ["paul.kelleher@contino.io", ]}
variable "alias" { default = "automated_deployment" }
variable "management_group" { default = "UK" }



variable "owner_assignments" { default = [] }
variable "contributor_assignments" { default = [] }
variable "reader_assignments" { default = [] }
variable "create_automation_repo" { default = false }
#variable "ORG_GH_TOKEN" {}


variable "billing_account" { default = "87561154" }
variable "enrollment_account" { default = "311200" }


locals {

    create_service_principal = true
    create_budgeet = true
    associate_management_group = true
    create_shared_remote_backend = true

    backend_container_name = lower(replace("${var.alias}state", "_", "-"))
    subscription_display_name = join(" ", [var.alias, var.purpose])
    subscription_alias = join(" ", [var.alias, var.owner])

    template_repo_org = "pknw1"
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

    repository_name="${var.alias}_auto_reposigtory"

    owner_assignments = var.owner_assignments == [] ? "no additional users" : jsonencode(var.owner_assignments)
    contributor_assignments = var.contributor_assignments == [] ? "no additional users" : jsonencode(var.contributor_assignments)
    reader_assignments = var.reader_assignments == [] ? "no additional users" : jsonencode(var.reader_assignments)

}

*/

variable "owner"    { }
variable "purpose"  { }
variable "email"    { }
variable "alias"    { }

module "azurerm_ea_subscription" {
    source="../"

    owner                   = var.owner 
    email                   = var.email
    purpose                 = var.purpose
    alias                   = var.alias


    # optional parameters
    # billing_account         = var.billing_account
    # enrollment_account      = var.enrollment_account
    # apply_budget            = var.apply_budget
    # management_group        = var.management_group
    # owner_assignments       = var.owner_assignments
    # contributor_assignments = var.contributor_assignments
    # reader_assignments      = var.reader_assignments
    # create_automation_repo  = var.create_automation_repo


}

