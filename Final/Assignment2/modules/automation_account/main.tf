resource "azurerm_automation_account" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
  tags                = var.tags
}

resource "azurerm_automation_schedule" "weekly_patching" {
  name                    = "WeeklyPatchDeployment"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.main.name
  frequency               = "Week"
  interval                = 1
  start_time              = var.schedule_start_time
  timezone                = var.timezone
  description             = "Weekly patch deployment schedule"
}

resource "azurerm_automation_runbook" "patch_deployment" {
  name                    = "Weekly-PatchDeployment"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.main.name
  log_verbose             = "true"
  log_progress            = "true"
  runbook_type            = "PowerShell"

  content = <<CONTENT
<#
.SYNOPSIS
    Weekly patch deployment for Azure VMs
.DESCRIPTION
    Applies all critical and security updates to target VMs
    with optional reboot if required
#>
param(
    [Parameter(Mandatory=$true)]
    [string[]]$VMNames,
    
    [Parameter(Mandatory=$false)]
    [bool]$RebootIfRequired = $true
)

# Connect to Azure Automation
$AutomationAccount = Get-AzAutomationAccount -ResourceGroupName "${var.resource_group_name}" -Name "${azurerm_automation_account.main.name}"

foreach ($vm in $VMNames) {
    try {
        Write-Output "Starting patch deployment for $vm"
        
        # Create update deployment
        $deploymentParams = @{
            ResourceGroupName     = $AutomationAccount.ResourceGroupName
            AutomationAccountName = $AutomationAccount.AutomationAccountName
            VMName               = $vm
            UpdateClassification = "Critical, Security"
            RebootOption         = if ($RebootIfRequired) { "RebootIfRequired" } else { "NeverReboot" }
            Duration             = "PT4H" # 4 hour timeout
            Name                 = "WeeklyPatch-$vm-$(Get-Date -Format 'yyyyMMdd')"
        }
        
        New-AzAutomationSoftwareUpdateConfiguration @deploymentParams
        
        Write-Output "Successfully scheduled patches for $vm"
    }
    catch {
        Write-Error "Failed to deploy patches to $vm: $_"
    }
}
CONTENT
}

resource "azurerm_automation_job_schedule" "weekly_patching" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.main.name
  schedule_name           = azurerm_automation_schedule.weekly_patching.name
  runbook_name            = azurerm_automation_runbook.patch_deployment.name

  parameters = {
    VMNames         = jsonencode(var.target_vms)
    RebootIfRequired = var.reboot_after_patching ? "true" : "false"
  }
}