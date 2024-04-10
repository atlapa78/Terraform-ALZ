variable "fw_policy_rg" {
  type        = string
  description = "Name for the resource group for the Azure Firewall Policy"
}

variable "fw_policy_name" {
  type        = string
  description = "Name for the Azure Firewall Policy"
}

variable "location" {
  type        = string
  description = "location of the resources"
}
