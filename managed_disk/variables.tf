variable "location" {
  type        = string
  description = "location of the resources"
}

variable "rgname" {
  type        = string
  description = "resource group for key vault"

}

variable "disk_name" {
  type        = string
  description = "name of the managed disk"

}

variable "disk_type" {
  type        = string
  description = "type of the managed disk. Possible values are Standard_LRS, StandardSSD_ZRS, Premium_LRS, PremiumV2_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS."
  default     = "Standard_LRS"
}

variable "disk_size" {
  type        = number
  description = "value"
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}