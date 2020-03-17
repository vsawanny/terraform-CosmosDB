variable "resource_group_name" {
default = "cosmosrg"
}
variable "resource_group_location" {
default = "australiaeast"
}
variable "subscription_id" {
default = "<PUT_YOUR_SUBSCRIPTION_ID_HERE>"
}
variable "tenant_id" {
default = "<PUT_YOUR_TENANT_ID_HERE>"
}
variable "cosmos_db_account_name" {
default = "velidacosmosterraform"
}
variable "failover_location" {
default = "australiasoutheast"
}
variable "cosmosdb_account_config" {
type = list(object({
name = string
kind = string
offer_type = string
enable_automatic_failover = bool
consistency_level = string
type = string
}))
}
