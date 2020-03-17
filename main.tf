provider "azurerm" {
version = "=1.44.0"
# features {}
}
resource "azurerm_resource_group" "rg" {
name = "${var.resource_group_name}"
location = "${var.resource_group_location}"
}
resource "azurerm_cosmosdb_account" "acc" {
count = length(var.cosmosdb_account_config)
name = "${var.cosmosdb_account_config[count.index].name}"
offer_type = var.cosmosdb_account_config[count.index].offer_type
kind = var.cosmosdb_account_config[count.index].kind
enable_automatic_failover = var.cosmosdb_account_config[count.index].enable_automatic_failover
consistency_policy {
consistency_level = var.cosmosdb_account_config[count.index].consistency_level
max_interval_in_seconds = 10 //must be over 5mins
max_staleness_prefix = 500 //must be over 100,000
}
geo_location {
location = "${azurerm_resource_group.rg.location}"
failover_priority = 0
}
location = "${azurerm_resource_group.rg.location}"
resource_group_name = "${azurerm_resource_group.rg.name}"
}
locals {
sqlObject = length(var.cosmosdb_account_config) > 0 ? [for obj in var.cosmosdb_account_config : obj if upper(obj.type) == "SQL"] : []
mongoObject = length(var.cosmosdb_account_config) > 0 ? [for obj in var.cosmosdb_account_config : obj if upper(obj.type) == "MONGO"] : []
}
resource "azurerm_cosmosdb_sql_database" "db" {
count = length(var.cosmosdb_account_config)
name = "sqldb"
resource_group_name = "${azurerm_resource_group.rg.name}"
account_name = "${element(azurerm_cosmosdb_account.acc[*].name,0)}"
depends_on = [azurerm_cosmosdb_account.acc , local.sqlObject]
}
resource "azurerm_cosmosdb_mongo_database" "mongodb" {
count = length(var.cosmosdb_account_config)
name = "mongodb"
resource_group_name = "${azurerm_resource_group.rg.name}"
account_name = "${element(azurerm_cosmosdb_account.acc[*].name,1)}"
depends_on = [azurerm_cosmosdb_account.acc , local.mongoObject]
}
resource "azurerm_cosmosdb_sql_container" "coll" {
count = length(var.cosmosdb_account_config)
name = "sqlcontainer"
resource_group_name = "${azurerm_resource_group.rg.name}"
account_name = "${element(azurerm_cosmosdb_account.acc[*].name,0)}"
database_name = "${azurerm_cosmosdb_sql_database.db[count.index].name}"
partition_key_path = "/ClothesId"
depends_on = [azurerm_cosmosdb_sql_database.db ,local.sqlObject]
}



resource "azurerm_cosmosdb_mongo_collection" "mongocontainer" {
count = length(var.cosmosdb_account_config)
name = "mongoContainer"
resource_group_name = "${azurerm_resource_group.rg.name}"
account_name = "${element(azurerm_cosmosdb_account.acc[*].name,1)}"
database_name = "${azurerm_cosmosdb_mongo_database.mongodb[count.index].name}"
depends_on = [azurerm_cosmosdb_mongo_database.mongodb ,local.mongoObject]
}
