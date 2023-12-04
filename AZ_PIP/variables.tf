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
  default     = "Dynamic"  
}