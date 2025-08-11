output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "vm_id" {
  description = "The full Azure Resource ID of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "The name of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.name
}