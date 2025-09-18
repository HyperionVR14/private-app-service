locals {
  sa_name = lower(replace("${var.name_prefix}sa", "-", ""))
}

resource "azurerm_storage_account" "sa" {
  name                     = local.sa_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # ключово изискване
  public_network_access_enabled = false

  min_tls_version             = "TLS1_2"
  allow_nested_items_to_be_public = false
}

# Private Endpoint за blob
resource "azurerm_private_endpoint" "pe_blob" {
  name                = "${var.name_prefix}-pe-blob"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "blob-conn"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns"
    private_dns_zone_ids = [var.blob_dns_zone_id]
  }
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