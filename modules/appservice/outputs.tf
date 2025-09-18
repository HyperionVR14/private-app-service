output "private_ip"   {
  value = data.azurerm_private_endpoint_connection.web_conn.private_service_connection[0].private_ip_address
}
output "private_fqdn" {
  value = "${azurerm_linux_web_app.app.name}.privatelink.azurewebsites.net"
}
output "webapp_name"  {
  value = azurerm_linux_web_app.app.name
}