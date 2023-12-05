variable "rgname" {
  type        = string
  description = "resource group for laws"
}


variable "location" {
  type        = string
  description = "location of the resources"
}

variable "laws_name" {
  type        = string
  description = "name of resource group"
}

variable "laws_sku" {
  type        = string
  description = "SKU for the log analytics workspace"
  validation {
    condition     = contains(["Free", "Standard", "CapacityReservation", "PerGB2018"], var.laws_sku)
    error_message = "Valid values for the log analytics work space variable are Free, Standard, CapacityReservation"
  }
  default = "PerGB2018"
}

variable "retention_days" {
  type        = number
  description = "retention in days for log analytics work space"
  default     = 30
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}
