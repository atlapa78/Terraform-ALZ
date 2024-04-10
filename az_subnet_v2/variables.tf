variable "subnet_name" {
  description = "name of the Azure subnet"
  
}

variable "rgname" {
  description = "Resource group where the resources are going to be created"
  type        = string
}

# variable "location" {
#   description = "Location for the resources"
#   type = string

# }

variable "vnet" {
  description = "Name of the virtual network"
  type = string

}


variable "address_space" {
  description = "CIDR of the subnet"
  type        = list(any)
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}
