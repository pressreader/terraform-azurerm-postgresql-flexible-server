# Azure PostgreSQL Flexible Server Terraform module

Terraform module which creates PostgreSQL Flexible Server in Azure

## Usage

```terraform
module "postgresql_flexible_server" {
  source = "git::https://github.com/pressreader/terraform-azurerm-postgresql-flexible-server.git?ref=v1.0.0"

  name                = "Name of a PostgreSQL Flexible Server"
  location            = "Location of the PostgreSQL Flexible Server"
  resource_group_name = "Resource group of the PostgreSQL Flexible Server"
  tags                = "Tags of the PostgreSQL Flexible Server"

  sku_name   = "SKU Name for the PostgreSQL Flexible Server"
  storage_mb = 32768
  version    = 14

  administrator_login    = "Username"
  administrator_password = "Password"

  backup_retention_days        = 7     # Defaults to 7
  geo_redundant_backup_enabled = false # Defaults to false

  delegated_subnet_id = "ID of a subnet"           # Defaults to null
  private_dns_zone_id = "ID of a private DNS zone" # Defaults to null

  # Optional
  high_availability = {
    mode                      = "SameZone" # Defaults to SameZone
    standby_availability_zone = "Zone 1"   # Defaults to null
  }

  # Optional
  maintenance_window = {
    day_of_week  = 0     # Defaults to 0
    start_hour   = 0     # Defaults to 0
    start_minute = 0     # Defaults to 0
  }

  # Optional
  configurations = [
    {
      name  = "backslash_quote" # Defaults to null
      value = "on"              # Defaults to null
    }
  ]

  # Optional
  firewall_rules = [
    {
      name             = "Name of a firewall rule"     # Defaults to null
      start_ip_address = "122.122.0.0" # Defaults to null
      end_ip_address   = "122.122.0.0" # Defaults to null
    }
  ]

  # Optional
  databases = [
    {
      name      = "Name of a database" # Defaults to null
      charset   = "utf8"               # Defaults to utf8
      collation = "en_US.utf8"         # Defaults to en_US.utf8
    }
  ]

  # Optional
  role_assignments = [
    {
      principal_id         = "ID of a principle" # Defaults to null
      role_definition_name = "Name of a role"    # Defaults to null
    }
  ]
}
```