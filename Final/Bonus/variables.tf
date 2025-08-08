variable "rg_name" {
  description = "Name of the resource group"
  type        = string
  validation {
    condition     = length(var.rg_name) <= 90 && can(regex("^[a-zA-Z0-9-_]+$", var.rg_name))
    error_message = "Resource group name must be alphanumeric, underscore, or hyphen and max 90 characters."
  }
}

variable "loc" {
  description = "Name of the location"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vm_config" {
  type = object({
    name              = string
    size              = string
    admin_username    = string
    ssh_public_key    = string
    webserver_package = string
    startup_commands  = list(string)
  })
}

variable "network_config" {
  type = object({
    vnet_name     = string
    address_space = string
    subnet_name   = string
    subnet_prefix = string
  })
}

variable "nsg_config" {
  type = object({
    name  = string
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  })
}


variable "environment" {
  description = "The deployment environment (dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vm_names" {
  description = "List of VM resource IDs to onboard to Update Management"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    Owner       = "IT Operations"
    CostCenter  = "IT123"
  }
}

variable "alert_action_group_id" {
  description = "The ID of the action group for alerts"
  type        = string
  default     = null
}