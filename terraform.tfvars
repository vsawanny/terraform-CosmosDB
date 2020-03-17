cosmosdb_account_config = [
{
name = "cosmodb1"
offer_type = "Standard"
kind = "GlobalDocumentDB"
enable_automatic_failover = true
consistency_level = "BoundedStaleness"
type = "sqldb"

},
{
name = "cosmodb2"
offer_type = "Standard"
kind = "MongoDB"
enable_automatic_failover = true
consistency_level = "BoundedStaleness"
type = "mongodb"
}
]
