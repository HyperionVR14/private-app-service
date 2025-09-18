output "private_ip"    { value = module.appservice.private_ip }
output "private_fqdn"  { value = module.appservice.private_fqdn }
output "webapp_name"   { value = azurerm_linux_web_app.app.name }
