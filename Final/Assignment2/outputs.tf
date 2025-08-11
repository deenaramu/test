output "automation_account_name" {
  description = "The name of the created Automation Account"
  value       = module.automation_account.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = module.log_analytics.workspace_id
}

output "update_management_status" {
  description = "Map of VM names to their OMS Agent extension IDs"
  value       = module.update_management.oms_agent_extensions
}

output "patch_schedule_id" {
  description = "The ID of the weekly patch deployment schedule"
  value       = module.update_management.patch_schedule_id
}