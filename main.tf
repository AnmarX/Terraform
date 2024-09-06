# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  features {}
}

# 3. Create a resource group
resource "azurerm_resource_group" "test" {
  name     = "test-azure"
  location = "Qatar Central"
  tags = {
    environment = "dev"
  }

}


# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "my-test-Vnet"
  address_space       = [var.addresss_space_Vnet]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  tags = {
    environment = "dev"
  }
}


resource "azurerm_subnet" "firstSubnet" {
  name                 = "first-subnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.first_subnet]
}

resource "azurerm_subnet" "secondSubnet" {
  name                 = "second-subnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.second_subnet]
}


resource "azurerm_network_security_group" "my_security_group" {
  name                = "my-security-groups-and-rules"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  security_rule {
    name                       = "first-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" # inbound that mean the source is from external request(api,user from the internet)
    destination_port_range     = "*" # inbound azure resources are destination
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "second-rule"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" # Outbound that mean the source is from azure resources
    destination_port_range     = "*" # Outbound that mean the destination is to external (api,user from the internet)
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}