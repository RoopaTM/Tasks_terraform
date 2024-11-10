#This tf is for implementing Key valut 

# Required Providers and Configuration
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


#------storing windows vm password in vault

# Fetch the Windows VM password from Key Vault
data "azurerm_key_vault_secret" "windows_vm_password" {
  name         = "windows-vm-password" # The name of the secret for VM password in Key Vault
  key_vault_id = "/subscriptions/547278e7-01d9-4f7c-9e1d-b32e9dc1d729/resourceGroups/Roopa-azure/providers/Microsoft.KeyVault/vaults/heykey"
}

data "azurerm_resource_group" "rg" {
  name = "Roopa-azure" #This resource group already exist in azure cloud
}




# Define the Virtual Network (replace with your existing VNet ID or create a new one)
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}




resource "azurerm_subnet" "example" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}



# Define the Network Interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "example-ip-config"
    subnet_id                     = azurerm_subnet.example.id # Reference the subnet from above
    private_ip_address_allocation = "Dynamic"
  }
}



# Create a Windows Virtual Machine using the password from Key Vault
resource "azurerm_windows_virtual_machine" "example" {
  name                = "windows-vm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.windows_vm_password.value # Using the secret value

  network_interface_ids = [
    azurerm_network_interface.example.id,
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


# Output the VM password 
output "secret_value" {
  value = data.azurerm_key_vault_secret.windows_vm_password.value
}


