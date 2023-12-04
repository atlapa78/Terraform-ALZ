variable "az_lb_name" {
  type        = string
  description = "Name of the load balancer"
  
}

variable "location" {
  type        = string
  description = "Location of the load balancer"  
}

variable "rgname" {
  type        = string
  description = "Name of resource group where automation account is going to reside"
  
}

variable "lb_sku" {
  type        = string
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Standard and Gateway."
  
}

variable "frontend_name" {
  type        = string 
  description =  "Name of the front end IP" 
}

# variable "public_ip_address_id" {
#   type        = string
#   description = "ID of the front end IP"  
# }

variable "subnet_lb_id" {
  type        = string
  description = "Id of subnet for the Load balancer" 
}

variable "private_ip_allocation" {
  type  = string
  description = "Allocation type for the private IP address"  
}

variable "private_ip" {
  description = "The private IP for the load balancer"  
}