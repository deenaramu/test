provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.loc
  tags     = var.tags

  lifecycle {
    prevent_destroy = false # Set to true in production
  }
}

module "network" {
  source              = "../Assignment1/modules/network"
  vnet_name           = var.network_config.vnet_name
  address_space       = var.network_config.address_space
  subnet_name         = var.network_config.subnet_name
  subnet_prefix       = var.network_config.subnet_prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "nsg" {
  source              = "../Assignment1/modules/nsg"
  nsg_name            = var.nsg_config.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  rules               = var.nsg_config.rules
}

module "vm" {
  source              = "../Assignment1/modules/vm"
  vm_name             = var.vm_config.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = var.vm_config.size
  admin_username      = var.vm_config.admin_username
  ssh_public_key      = var.vm_config.ssh_public_key
  subnet_id           = module.network.subnet_id
  nsg_id              = module.nsg.nsg_id
  webserver_package   = var.vm_config.webserver_package
  startup_commands    = var.vm_config.startup_commands
}

output "linux_vm_id" {
  description = "Full resource ID of the Linux VM"
  value       = module.vm.vm_id  # This will be in the format you want
}

module "log_analytics" {
  source              = "../Assignment2/modules/log_analytics"
  name                = "patch-mgmt-logs-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "automation_account" {
  source              = "../Assignment2/modules/automation_account"
  name                = "patch-automation-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "update_management" {
  source                      = "../Assignment2/modules/update_management"
  resource_group_name         = var.resource_group_name
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  log_analytics_workspace_key = module.log_analytics.primary_shared_key
  automation_account_id       = module.automation_account.id
  automation_account_name     = module.automation_account.name
  vm_ids                 = module.vm.vm_id 
}
