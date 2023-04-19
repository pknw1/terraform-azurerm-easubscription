
variable "owner" { default = "" }
variable "purpose" { default = "" }
variable "email" { default = [] }
variable "alias" { default = "" }

variable "management_group" { default = "UK" }
variable "create_automation_repo" { default = false }

variable "apply_budget" { default = true }
variable "billing_account" { default = "87561154" }
variable "enrollment_account" { default = "311200" }
variable "create_service_principal" { default = false}
variable "service_principal_display_name" { default = ""}
variable "github_username" { default = "" }
variable "template_repo_org" { default = ""}
variable "template_repo" { default = ""}

