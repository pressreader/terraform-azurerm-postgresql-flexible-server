variable "name" {
  description = "PostgreSQL flexible server name"
  type        = string
}

variable "location" {
  description = "PostgreSQL flexible server location"
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name to put the flexible server in"
  type        = string
}

variable "tags" {
  description = "A mapping of tags which should be assigned to the PostgreSQL Flexible Server"
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "The SKU Name for the PostgreSQL Flexible Server. Example: GP_Standard_D2s_v3"
  type        = string
}

variable "storage_mb" {
  description = "The max storage in Mb allowed for the PostgreSQL Flexible Server."
  type        = number

  validation {
    condition = contains([
      32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216
    ], var.storage_mb)
    error_message = "The storage_mb value must be one of 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216"
  }
}

variable "postgresql_version" {
  description = "The version of PostgreSQL Flexible Server to use."
  type        = number

  validation {
    condition     = contains([11, 12, 13, 14, 15, 16], var.postgresql_version)
    error_message = "The postgresql_version value must be one of 11, 12, 13 and 14"
  }
}

variable "administrator_login" {
  description = "The Administrator login for the PostgreSQL Flexible Server"
  type        = string
}

variable "administrator_password" {
  description = "The Password associated with the administrator_login for the PostgreSQL Flexible Server"
  type        = string
}

variable "backup_retention_days" {
  description = "The backup retention days for the PostgreSQL Flexible Server. Possible values are between 7 and 35 days"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 35
    error_message = "The backup_retention_days value must be in between 7 and 35"
  }
}

variable "geo_redundant_backup_enabled" {
  description = "Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created."
  type        = bool
  default     = false
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to create the PostgreSQL Flexible Server"
  type        = string
  default     = null
}

variable "delegated_subnet_id" {
  description = "The ID of the virtual network subnet to create the PostgreSQL Flexible Server. The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. "
  type        = string
  default     = null
}
variable "public_network_access_enabled" {
  description = "(Optional) Specifies whether this PostgreSQL Flexible Server is publicly accessible. Defaults to true "
  type        = bool
  default     = true
}
variable "high_availability" {
  description = <<EOT
  <br><b>mode:</b> The high availability mode for the PostgreSQL Flexible Server. Possible value are SameZone or ZoneRedundant.
EOT
  type = object({
    mode = optional(string)
  })
  default = null
}

variable "maintenance_window" {
  description = <<EOT
  <br><b>day_of_week:</b> The day of week for maintenance window, where the week starts on a Sunday, i.e. Sunday = 0, Monday = 1. Defaults to 0.
  <br><b>start_hour:</b> The start hour for maintenance window. Defaults to 0.
  <br><b>start_minute:</b> The start minute for maintenance window. Defaults to 0.
EOT
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  default = null
}

variable "configurations" {
  description = <<EOT
  <br><b>name:</b> Specifies the name of the PostgreSQL Configuration, which needs to be a valid PostgreSQL configuration name. Changing this forces a new resource to be created.
  <br><b>value:</b> Specifies the value of the PostgreSQL Configuration. See the PostgreSQL documentation for valid values.
EOT
  type = list(object({
    name  = optional(string)
    value = optional(string)
  }))
  default = []
}

variable "firewall_rules" {
  description = <<EOT
  <br><b>name:</b> The name which should be used for this PostgreSQL Flexible Server Firewall Rule. Changing this forces a new PostgreSQL Flexible Server Firewall Rule to be created.
  <br><b>start_ip_address:</b> The Start IP Address associated with this PostgreSQL Flexible Server Firewall Rule.
  <br><b>end_ip_address:</b> The End IP Address associated with this PostgreSQL Flexible Server Firewall Rule.
EOT
  type = list(object({
    name             = optional(string)
    start_ip_address = optional(string)
    end_ip_address   = optional(string)
  }))
  default = []
}

variable "databases" {
  description = <<EOT
  <br><b>name:</b> The name which should be used for this Azure PostgreSQL Flexible Server Database. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created.
  <br><b>charset:</b> Specifies the Charset for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Charset. Defaults to utf8. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created.
  <br><b>collation:</b> Specifies the Collation for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Collation. Defaults to en_US.utf8. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created.
EOT
  type = list(object({
    name      = optional(string)
    charset   = optional(string, "utf8")
    collation = optional(string, "en_US.utf8")
  }))
  default = []
}

variable "role_assignments" {
  description = <<EOT
  <br><b>principal_id:</b> The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created.
  <br><b>role_definition_name:</b> The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with role_definition_id.
EOT
  type = list(object({
    principal_id         = optional(string)
    role_definition_name = optional(string)
  }))
  default = []
}
