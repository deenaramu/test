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
  source              = "./modules/network"
  vnet_name           = var.network_config.vnet_name
  address_space       = var.network_config.address_space
  subnet_name         = var.network_config.subnet_name
  subnet_prefix       = var.network_config.subnet_prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "nsg" {
  source              = "./modules/nsg"
  nsg_name            = var.nsg_config.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  rules               = var.nsg_config.rules
}

module "vm" {
  source              = "./modules/vm"
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
