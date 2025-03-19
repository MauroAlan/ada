variable "sql_admin_login" {
  type    = string
  default = "BANCODEDADOS"
}
#DEFINIDA VARIAVEIS PARA USO PORTERIOR
variable "sql_admin_password" {
  type      = string
  default   = "123456789qwE@"
  sensitive = true
}

#CRIACAO DO SQL SERVER
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "mybancodedadis"
  resource_group_name          = azurerm_resource_group.grupo-recursos-ada.name
  location                     = azurerm_resource_group.grupo-recursos-ada.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  tags = {
    environment = "production"
  }
}
#DEFINICAO DO BANCO DE DADOS
resource "azurerm_mssql_database" "db" {
  name        = "BancoProjetoAda"
  server_id   = azurerm_mssql_server.sqlserver.id
  sku_name    = "Basic"
  max_size_gb = 1

  tags = {
    environment = "production"
  }
}
resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv.id
}
#Regra de firewall para o SQL SERVER nao barrar o IP
resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name             = "VEJAMEUIP"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "74.163.213.146"
  end_ip_address   = "74.163.213.146"
}
