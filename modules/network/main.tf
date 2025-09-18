resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "snet_app" {
  name                 = "snet-app"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.snet_app_cidr]

  delegation {
    name = "webapp-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "snet_pe" {
  name                 = "snet-privatelink"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.snet_pe_cidr]

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_subnet" "snet_test" {
  name                 = "snet-test"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.snet_test_cidr]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name_prefix}-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "AllowVnetInBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyInternetInBound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = azurerm_subnet.snet_app.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "pe_assoc" {
  subnet_id                 = azurerm_subnet.snet_pe.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "test_assoc" {
  subnet_id                 = azurerm_subnet.snet_test.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
