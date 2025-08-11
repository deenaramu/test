output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = module.vm.public_ip
}

output "vm_id" {
  description = "The full Azure Resource ID of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "The name of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.name
}