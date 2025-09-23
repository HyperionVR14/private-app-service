output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "storage_account_id" {
  value = azurerm_storage_account.sa.id
}

output "blob_private_endpoint_id" {
  value = azurerm_private_endpoint.pe_blob.id
}

output "blob_private_ip" {
  value = try(data.azurerm_private_endpoint_connection.blob_conn.private_service_connection[0].private_ip_address, null)
}
