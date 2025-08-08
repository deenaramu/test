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