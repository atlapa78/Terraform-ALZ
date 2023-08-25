variable "vault_name" {
  type        = string
  description = "resource group for key vault"
}


variable "location" {
  type        = string
  description = "location of the resources"
}

variable "rgname" {
  type        = string
  description = "resource group for key vault"

}

variable "sku_name" {
  type        = string
  description = "SKU for the keyvault"
  default     = "standard"
}

variable "key_permissions" {
  type        = list(string)
  description = "List of key permissions."
  default     = ["List", "Create", "Delete", "Get", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy", ]
}

variable "secret_permissions" {
  type        = list(string)
  description = "List of secret permissions."
  default     = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set", ]
}

# variable "msi_id" {
#   type        = string
#   description = "The Managed Service Identity ID. If this value isn't null (the default), 'data.azurerm_client_config.current.object_id' will be set to this value."
#   default     = null
# }

variable "tenant_id" {
  type        = string
  description = "tenant ID for the keyvault"
}

variable "object_id" {
  type        = string
  description = "object ID of the current service principal for the keyvault"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of day for the retention"
}

