variable "storageaccountname" {
  type        = string
  description = "Name of the storage account"
}

variable "rgname" {
  type        = string
  description = "resource group for storage account"
}

variable "location" {
  type        = string
  description = "Location for storage account"
}

variable "account_tier" {
  type        = string
  description = "Tier for storage account, valid values: Standard, Premium"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Replication to use for storage account, valid values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS"
  default     = "LRS"
}

variable "account_kind" {
  type        = string
  description = " Kind of account. Valid options are: BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  default     = "StorageV2"
}