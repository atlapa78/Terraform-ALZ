variable "vault_name" {
  type = string
  description = "Name used for the recovery services vault"
  
}

variable "location" {
  type        = string
  description = "location of the resources"
}

variable "rgname" {
  type        = string
  description = "resource group for key vault"
}

variable "rsv_sku" {
  type = string
  description = "(Required) Sets the vault's SKU. Possible values include: Standard, RS0."
  default = "Standard"
}