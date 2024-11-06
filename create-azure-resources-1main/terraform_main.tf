terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.6.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "547278e7-01d9-4f7c-9e1d-b32e9dc1d729"
}



resource "azurerm_resource_group" "roopa_resource_group" {
  name     = "Resourcegroup-terraform-roop"
  location = "West US"
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.roopa_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "my_public_ip_linux" {
  name                = "myPublicIPLinux"
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "my_nic" {
  name                = "myNic"
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name

  ip_configuration {
    name                          = "myIpConfiguration"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip_linux.id
  }
}




resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "roopaVMbytf"
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  location            = azurerm_resource_group.roopa_resource_group.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/my_azure_key.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.my_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Public IP for Windows VM
resource "azurerm_public_ip" "my_public_ip_windows" {
  name                = "myPublicIPWindows"
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NIC for Windows VM
resource "azurerm_network_interface" "my_nic_windows" {
  name                = "Nic_Windows"
  location            = azurerm_resource_group.roopa_resource_group.location
  resource_group_name = azurerm_resource_group.roopa_resource_group.name

  ip_configuration {
    name                          = "myIpConfigurationWindows"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip_windows.id
  }
}

# Windows VM
resource "azurerm_windows_virtual_machine" "my_vm_windows" {
  name                = "roopaVMbytfWin"
  resource_group_name = azurerm_resource_group.roopa_resource_group.name
  location            = azurerm_resource_group.roopa_resource_group.location
  size                = "Standard_DS1_v2"

  admin_username = "adminuser"
  admin_password = "roopa@123bengalore"

  network_interface_ids = [
    azurerm_network_interface.my_nic_windows.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Outputs
output "public_ip" {
  value = azurerm_public_ip.my_public_ip_linux.ip_address
}

output "public_ip_windows" {
  value = azurerm_public_ip.my_public_ip_windows.ip_address
}


