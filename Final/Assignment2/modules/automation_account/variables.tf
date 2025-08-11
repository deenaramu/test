variable "name" {
  description = "The name of the Automation Account"
  type        = string
}

variable "location" {
  description = "The Azure region where the Automation Account will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "schedule_start_time" {
  description = "The start time for weekly patching in RFC3339 format (e.g., '2023-01-01T02:00:00Z')"
  type        = string
}

variable "timezone" {
  description = "The timezone for the schedule (e.g., 'Eastern Standard Time')"
  type        = string
  default     = "UTC"
}

variable "target_vms" {
  description = "List of VM names to include in weekly patching"
  type        = list(string)
}

variable "reboot_after_patching" {
  description = "Whether to allow reboots after patching if required"
  type        = bool
  default     = true
}