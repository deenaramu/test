variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  type        = string
}

variable "log_analytics_workspace_key" {
  description = "The primary shared key of the Log Analytics workspace"
  type        = string
  sensitive   = true
}

variable "automation_account_id" {
  description = "The ID of the Automation Account"
  type        = string
}

variable "automation_account_name" {
  description = "The name of the Automation Account"
  type        = string
}

variable "vm_names" {
  description = "List of VM resource IDs to onboard to Update Management"
  type        = list(string)
  default     = []
}

variable "schedule_start_time" {
  description = "The start time for the patch schedule in RFC3339 format"
  type        = string
  default     = null
}

variable "schedule_timezone" {
  description = "The timezone for the patch schedule"
  type        = string
  default     = "UTC"
}