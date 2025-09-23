resource "azurerm_network_security_group" "workload_nsg" {
  name                = "${var.name_prefix}-workload-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  # Inbound: позволи само вътрешен (VNet)
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

  # Inbound: изрично забрани от Internet
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

  # Outbound: позволи вътрешен (VNet)
  security_rule {
    name                       = "AllowVnetOutBound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  # Outbound: забрани към Internet
  security_rule {
    name                       = "DenyInternetOutBound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}