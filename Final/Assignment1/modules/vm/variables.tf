variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  validation {
    condition     = length(var.vm_name) <= 64 && can(regex("^[a-zA-Z0-9-]+$", var.vm_name))
    error_message = "VM name must be alphanumeric with hyphens, max 64 characters."
  }
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}

variable "nsg_id" {
  description = "ID of the network security group to associate with the VM"
  type        = string
}

variable "webserver_package" {
  description = "Web server package to install (nginx, apache2, etc.)"
  type        = string
  default     = "nginx"
}


