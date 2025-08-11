output "automation_account_id" {
  description = "The ID of the Automation Account"
  value       = azurerm_automation_account.main.id
}

output "schedule_id" {
  description = "The ID of the weekly patch schedule"
  value       = azurerm_automation_schedule.weekly_patching.id
}

output "runbook_name" {
  description = "The name of the patch deployment runbook"
  value       = azurerm_automation_runbook.patch_deployment.name
}