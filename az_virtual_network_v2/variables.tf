variable "vnetname" {
  description = "name of the Azure vnet"
  type        = string
}

variable "rgname" {
  description = "Resource group where the resources are going to be created"
  type        = string
}

variable "location" {
  description = "Location for the resources"
  type = string

}

variable "address_space" {
  description = "CIDR of the vnet"
  type        = list(any)
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}
