locals {
  prefix          = "${var.company}-${var.workload}-${var.environment}"
  unique          = "${local.prefix}-${var.name_suffix}"
  application_insights_name = lower("${local.prefix}-ai")
  sql_server_name = lower("${local.prefix}-sql")
  web_app_name    = lower("${local.prefix}-web")
  kv_name         = substr(lower(replace("${var.company}${var.workload}${var.environment}kv", "-", "")), 0, 24)
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.unique}-rg"
  location = var.location
}

resource "azurerm_application_insights" "ai" {
  name                = local.application_insights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = local.kv_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

timeouts {
    create  = "30m"
    read    = "10m"
    update  = "30m"
    delete  ="30m"
}
}

resource "azurerm_mssql_server" "sql" {
  name                         = local.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_user
  administrator_login_password = var.sql_admin_password

  public_network_access_enabled = true
}

resource "azurerm_mssql_database" "db" {
  name           = var.db_name
  server_id      = azurerm_mssql_server.sql.id
  sku_name       = "GP_S_Gen5_2"
  zone_redundant = true
}

# Allow Azure services (App Service) to reach SQL (simple + deployable)
resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name            = "AllowAzureServices"
  server_id       = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_service_plan" "plan" {
  name                = "${local.unique}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web" {
  name                = local.web_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    always_on         = true
    health_check_path = "/health"
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.ai.instrumentation_key

    DB_SERVER   = "${azurerm_mssql_server.sql.name}.database.windows.net"
    DB_NAME     = azurerm_mssql_database.db.name
    DB_USER     = var.sql_admin_user
    DB_PASSWORD = var.sql_admin_password
  }
}
