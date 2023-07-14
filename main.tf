resource "azurerm_postgresql_flexible_server" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku_name   = var.sku_name
  storage_mb = var.storage_mb
  version    = var.postgresql_version

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  dynamic "high_availability" {
    for_each = var.high_availability != null ? toset([var.high_availability]) : toset([])

    content {
      mode                      = var.high_availability.mode
      standby_availability_zone = var.high_availability.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? toset([var.maintenance_window]) : toset([])

    content {
      day_of_week  = maintenance_window.value["day_of_week"]
      start_hour   = maintenance_window.value["start_hour"]
      start_minute = maintenance_window.value["start_minute"]
    }
  }

  lifecycle {
    precondition {
      condition     = var.private_dns_zone_id != null && var.delegated_subnet_id != null || var.private_dns_zone_id == null && var.delegated_subnet_id == null
      error_message = "var.private_dns_zone_id and var.delegated_subnet_id should either both be set or none of them."
    }
  }
}

resource "azurerm_postgresql_flexible_server_configuration" "main" {
  for_each = {for v in var.configurations : v["name"] => v}

  server_id = azurerm_postgresql_flexible_server.main.id
  name      = each.key
  value     = each.value
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  for_each = {for v in var.firewall_rules : v["name"] => v}

  server_id        = azurerm_postgresql_flexible_server.main.id
  name             = each.value["name"]
  start_ip_address = each.value["start_ip_address"]
  end_ip_address   = each.value["end_ip_address"]
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  for_each = {for v in var.databases : v["name"] => v}

  server_id = azurerm_postgresql_flexible_server.main.id
  name      = each.value["name"]
  charset   = each.value["charset"]
  collation = each.value["collation"]
}