variable "pip_name" {
  type        = string
  description = "Name of the public IP"

}

variable "location" {
  type        = string
  description = "Location of the public IP"

}

variable "rgname" {
  type        = string
  description = "Name of resource group where public IP is going to reside"

}

variable "allocation_method" {
  type        = string
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  default     = "static"
}

variable "pip_sku" {
  type        = string
  description = "The SKU of the Public IP. Accepted values are Basic and Standard,  Changing this forces a new resource to be created."
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}