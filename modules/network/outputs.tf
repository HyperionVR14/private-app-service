output "vnet_id"        { value = azurerm_virtual_network.vnet.id }
output "vnet_name"      { value = azurerm_virtual_network.vnet.name }
output "snet_app_id"    { value = azurerm_subnet.snet_app.id }
output "snet_pe_id"     { value = azurerm_subnet.snet_pe.id }
output "snet_test_id"   { value = azurerm_subnet.snet_test.id }
output "snet_test_name" { value = azurerm_subnet.snet_test.name }