output "resource_group"      { value = azurerm_resource_group.rg.name }
output "webapp_private_fqdn" { value = module.appservice.private_fqdn }
output "webapp_private_ip"   { value = module.appservice.private_ip }
output "webapp_name"         { value = module.appservice.webapp_name }
output "vnet_name"           { value = module.network.vnet_name }
output "snet_test_name"      { value = module.network.snet_test_name }
