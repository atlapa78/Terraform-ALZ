variable "rgname" {
  type        = string
  description = "name of resource group"
}

variable "rt_name" {
  type        = string
  description = "name of route_table"
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
  type        = string
}