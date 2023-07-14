resource "azurerm_role_assignment" "name" {
  for_each = {
    for v in var.role_assignments : "${v["principal_id"]} | ${v["role_definition_name"]}" => v
  }

  scope                = azurerm_postgresql_flexible_server.main.id
  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition_name
}