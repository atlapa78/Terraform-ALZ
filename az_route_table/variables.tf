variable "rgname" {
  type        = string
  description = "name of resource group"
}

variable "location" {
  type        = string
  description = "location of the resources"
}

variable "subnets" {
  type = map(any) 
}

variable "address_space" {
  description = "CIDR of the vnet"
  type        = list(any)
}