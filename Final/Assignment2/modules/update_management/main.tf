resource "azurerm_log_analytics_linked_service" "automation" {
  resource_group_name = var.resource_group_name
  workspace_id        = var.log_analytics_workspace_id
  read_access_id      = var.automation_account_id
}

resource "azurerm_virtual_machine_extension" "oms_agent" {
  for_each = toset(var.vm_names)

  name                       = "OmsAgentForLinux"
  virtual_machine_id         = each.value
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.13"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    "workspaceId" = var.log_analytics_workspace_id
  })

  protected_settings = jsonencode({
    "workspaceKey" = var.log_analytics_workspace_key
  })
}

resource "azurerm_automation_schedule" "weekly_patching" {
  name                    = "weekly-patching-schedule"
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  frequency               = "Week"
  interval                = 1
  start_time              = var.schedule_start_time != null ? var.schedule_start_time : timeadd(timestamp(), "24h")
  timezone                = var.schedule_timezone
  description             = "Weekly patching schedule"
}

resource "azurerm_automation_job_schedule" "patch_deployment" {
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  schedule_name           = azurerm_automation_schedule.weekly_patching.name
  runbook_name            = "Patch-MicrosoftOMSComputers"
}