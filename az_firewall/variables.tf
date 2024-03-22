variable "fw_name" {
  type        = string
  description = "Name of the Azure Firewall"  
}

variable "location" {
  type        = string
  description = "location of the resources"
}
variable "rgname" {
  type        = string
  description = "resource group for the azure firewall"
}

variable "fw_sku_name" {
  type        = string
  description = "(Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created"
  default     = "AZFW_VNet"
}


variable "fw_sku_tier" {
  type        = string
  description = "(Required) SKU tier of the Firewall. Possible values are Premium, Standard and Basic"
  default     = "Standard"
}


variable "fw_subnet_id" {
  type        = string
  description = " (Optional) Reference to the subnet associated with the IP Configuration. Changing this forces a new resource to be created."
}

variable "fw_pip_id" {
  type        = string
  description = " (Required) Public IP for the azure fw"
}