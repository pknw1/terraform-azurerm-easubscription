# Azure EA Subscription Creation

This module helps you to keep consistency on your resources names for Terraform The goal of this module it is that for each resource that requires a name in Terraform you would be easily able to compose this name using this module and this will keep the consistency in your repositories.

# Usage

The module can either be called directly 

```
module "azurerm_ea_subscription" {
    source="../"

    billing_account         = <value>
    enrollment_account      = <value> 

    owner                   = <value>
    email                   = <value>
    purpose                 = <value>
    alias                   = <value>

    # optional parameters
    apply_budget            = <value>
    management_group        = <value>

    create_service_principal = <value>
    service_principal_display_name = <value>
    
    create_automation_repo  = <value>
    github_username         = <value>
    template_repo_org       = <value>
    template_repo           = <value>
}
```

or, in a preferred configuration, by identifying config files in the subscription_configurations folder - each file iterated over to deliver a new subscription with
all of the options as set in the <any_filename>.json files


```

locals {
    json_files = fileset(path.module, "subscription_configurations/*json")   
    json_data  = [ for f in local.json_files : jsondecode(file("${f}")) ]  
}


module "azurerm_ea_subscription" {
    source="../"

    for_each = { for f in local.json_data : f.owner => f }

    all_variables_as_above  = each.value.variable_name_from_config_file

}

```

## Operating Guidance

1. This terraform requires very high role assignments and should ony be operated by automation with all secret values from secret stores
2. For each user, assuming all optional extra's are set to true, will
  * Identify the new subscription requestor in AD via their email address
  * Create a subscription under the supplied Billing Account and Enrolment account details provided
  * Add a subscription alias if provided
  
  optionally
  * Assign the included budget and budget notification scheme
  * Assign the subscription into the supplied Management Group (if one is supplied) 
  * Create a github repository to store automation code for this subscription
  * Create a service principal to run automation from Github 
  * Create the repository from either a supplied template repository, or if not, a blank repo
  * Pre-populate all the sensitive values for automation by storing the SP details in the Repository Secrets
  * Assigning appropriate roles for teh requester for all resources
    
## Trigger by Webhook

This repository can be triggered remotely for further integration with other systems

```
curl  -H "Authorization: token <token>" \
      -H 'Accept: application/vnd.github.everest-preview+json' \
      "https://api.github.com/repos/<owner>/<repository_name>/dispatches" 
      -d '{"event_type": "subscription-request", "client_payload": {"billing_account" : "87561154", "enrollment_account" : "311200","owner" : "paul.kelleher","email" : "paul.kelleher@contino.io","purpose" : "subscription_purpose","alias" : "subscription_alias","apply_budget" : true,"management_group" : "UK","create_automation_repo" : true,"github_username": "pknw1","template_repo_org" : "pknw1","template_repo" : "terraform-boilerplate","create_service_principal" : true,"service_principal_display_name" : "subscription_name_subscription"}}'
```

In sending the request and triggering the workflow, the POST body is stored as a `subscription_configurations/*json` file and can be comitted either directly to main 
and processed - or if some approvals were required, into a new branmch with a PR


```
name: example-client-payload-action
on: 
  repository_dispatch:
    types: [subscription-request]
jobs:
  easub:
    name: EA Subscription
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: 'echo "field: ${{ github.event.client_payload.foo }}"'
      - run: 'echo "payload: ${{ toJson(github.event.client_payload) }}"'
      - run: echo baz
        if: github.event.action == 'baz'
      - run: 'echo "payload: ${{ toJson(github.event.client_payload) }}" > newfile.txt'
      - run: 'cat newfile.txt'
```




name: example-client-payload-action
on: 
  repository_dispatch:
    types: [subscription-request]
jobs:
  easub:
    name: EA Subscription
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: 'echo "payload: ${{ toJson(github.event.client_payload) }}"'
      - run: 'echo "${{ toJson(github.event.client_payload) }}" > $(date +%s).json'
      - uses: stefanzweifel/git-auto-commit-action@v4
          with:
            commit_message: "updated_config"