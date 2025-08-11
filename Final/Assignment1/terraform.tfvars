rg_name = "nginx-rg"
loc = "West Europe"
vm_config = {
  name              = "web-vm"
  size              = "Standard_B1s"
  admin_username    = "azureuser"
  ssh_public_key    = file("~/.ssh/id_rsa.pub")
  webserver_package = "nginx"
  startup_commands  = [
    "systemctl enable nginx",
    "systemctl start nginx"
  ]
}

network_config = {
  vnet_name     = "web-vnet"
  address_space = "10.0.0.0/16"
  subnet_name   = "web-subnet"
  subnet_prefix = "10.0.1.0/24"
}

nsg_config = {
  name = "web-nsg"
  rules = [
    {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
