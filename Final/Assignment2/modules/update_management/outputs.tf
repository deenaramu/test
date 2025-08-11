output "oms_agent_extensions" {
  description = "Map of OMS Agent extensions deployed to VMs"
  value       = { for k, v in azurerm_virtual_machine_extension.oms_agent : k => v.id }
}

output "patch_schedule_id" {
  description = "The ID of the patch deployment schedule"
  value       = azurerm_automation_schedule.weekly_patching.id
}

output "linked_service_id" {
  description = "The ID of the Log Analytics linked service"
  value       = azurerm_log_analytics_linked_service.automation.id
}