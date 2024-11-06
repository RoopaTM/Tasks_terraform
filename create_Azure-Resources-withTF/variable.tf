variable "resource_group_name" {
  default = "roopa_terraform_rg"
}



variable "location" {
  default = "East US 2"
}



variable "address_space" {
  default = ["10.1.0.0/16"]
  type    = list(string)
}



variable "vnet_name" {
  default = "terraform_vnet"
}



variable "subnet_space" {
  default = ["10.1.0.0/24", "10.1.10.0/24"]
  type    = list(string)
}




variable "subnet_name" {
  default = "roopa_terraform_subnetnet"
}



variable "key" {
  default = "ssh_key"
}



variable "nic_name" {
  default = "terraform_nic"
}


variable "public_ip_name" {
  default = "public_ip"
}



variable "ip_name" {
  default = "ip"
}


variable "sku" {
  default = "22.04-LTS"
}


variable "vm_name" {
  default = "Roopatm-ubantu-TF"
}


variable "admin" {
  default = "azureuser"
}


variable "size" {
  default = "Standard_B1s"
}



variable "user" {
  default = "azureuser"
}


variable "nsg" {
  default = "Roopa-nsg"
}
