resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-asp"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.name_prefix}-web"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  # VNet Integration (outbound)
  virtual_network_subnet_id = var.app_subnet_id

  site_config {
    ftps_state = "Disabled"

    # Allow само app subnet
    ip_restriction {
      name                      = "allow-app-subnet"
      priority                  = 100
      action                    = "Allow"
      virtual_network_subnet_id = var.app_subnet_id
    }

    # Deny всички останали
    ip_restriction {
      name       = "deny-all"
      priority   = 65000
      action     = "Deny"
      ip_address = "0.0.0.0/0"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
  }
}

resource "azurerm_private_endpoint" "pe_web" {
  name                = "${var.name_prefix}-pe-web"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "web-conn"
    private_connection_resource_id = azurerm_linux_web_app.app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "webapps-dns"
    private_dns_zone_ids = [var.web_dns_zone_id]
  }
}

data "azurerm_private_endpoint_connection" "web_conn" {
  name                = azurerm_private_endpoint.pe_web.name
  resource_group_name = var.rg_name
  depends_on          = [azurerm_private_endpoint.pe_web]
}

