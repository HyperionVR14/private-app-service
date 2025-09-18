output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "storage_account_id" {
  value = azurerm_storage_account.sa.id
}

output "blob_private_endpoint_id" {
  value = azurerm_private_endpoint.pe_blob.id
}

# Ако искаш да връщаме и частното IP на PE-то, добави data source в main.tf (по-долу),
# след което този output ще работи:
output "blob_private_ip" {
  value = try(data.azurerm_private_endpoint_connection.blob_conn.private_service_connection[0].private_ip_address, null)
}
output "storage_account_name" { value = azurerm_storage_account.sa.name }
# Вземаме private IP-то на PE-то след като бъде създадено
data "azurerm_private_endpoint_connection" "blob_conn" {
  name                = azurerm_private_endpoint.pe_blob.name
  resource_group_name = var.rg_name

  depends_on = [
    azurerm_private_endpoint.pe_blob
  ]
}