resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

module "network" {
  source        = "./modules/network"
  rg_name       = azurerm_resource_group.rg.name
  location      = azurerm_resource_group.rg.location
  name_prefix   = var.name_prefix

  address_space  = "10.20.0.0/16"
  snet_app_cidr  = "10.20.1.0/24" # delegated Microsoft.Web/serverFarms
  snet_pe_cidr   = "10.20.2.0/24" # private endpoints
  snet_test_cidr = "10.20.3.0/24" # вътрешни тестове (VM), без публичен IP
}

module "privatedns" {
  source    = "./modules/privatedns"
  rg_name   = azurerm_resource_group.rg.name
  location  = azurerm_resource_group.rg.location
  vnet_id   = module.network.vnet_id
  depends_on = [
    module.network
  ]
}

module "storage" {
  source         = "./modules/storage"
  rg_name        = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  name_prefix    = var.name_prefix
  pe_subnet_id   = module.network.snet_pe_id
  blob_dns_zone_id = module.privatedns.blob_zone_id

  depends_on = [
    module.privatedns
  ]
}

module "appservice" {
  source          = "./modules/appservice"
  rg_name         = azurerm_resource_group.rg.name
  location        = azurerm_resource_group.rg.location
  name_prefix     = var.name_prefix
  app_subnet_id   = module.network.snet_app_id
  pe_subnet_id    = module.network.snet_pe_id
  web_dns_zone_id = module.privatedns.webapps_zone_id

  depends_on = [
    module.privatedns
  ]
}

output "resource_group"         { value = azurerm_resource_group.rg.name }
output "webapp_private_fqdn"    { value = module.appservice.private_fqdn }
output "webapp_private_ip"      { value = module.appservice.private_ip }
output "webapp_name"            { value = module.appservice.webapp_name }
output "vnet_name"              { value = module.network.vnet_name }
output "snet_test_name"         { value = module.network.snet_test_name }
