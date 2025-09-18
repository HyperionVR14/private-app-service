resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone" "webapps" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_link" {
  name                  = "blob-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "webapps_link" {
  name                  = "webapps-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.webapps.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}
