module "log_analytics" {
  source              = "./modules/log_analytics"
  name                = "patch-mgmt-logs-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "automation_account" {
  source              = "./modules/automation_account"
  name                = "patch-automation-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "update_management" {
  source                      = "./modules/update_management"
  resource_group_name         = var.resource_group_name
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  log_analytics_workspace_key = module.log_analytics.primary_shared_key
  automation_account_id       = module.automation_account.id
  automation_account_name     = module.automation_account.name
  vm_names                    = var.vm_names
}