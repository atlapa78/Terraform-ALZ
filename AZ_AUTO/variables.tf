variable "auto_name" {
  type        = string
  description = "Name of the automation account"
  
}

variable "location" {
  type        = string
  description = "Location of the automation account"
  
}

variable "rgname" {
  type        = string
  description = "Name of resource group where automation account is going to reside"
  
}

variable "aut_acc_sku" {
  type        = string
  description = " (Required) The SKU of the account. Possible values are Basic and Free"
  default     = "free"  
}