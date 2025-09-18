terraform {
  backend "azurerm" {
    resource_group_name  = "RG-Lab"
    storage_account_name = "kristiyansterraform"
    container_name       = "private-app"
    key                  = "terraform.private-app"
    use_azuread_auth     = true
  }
}