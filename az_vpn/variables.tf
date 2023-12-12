variable "vpn_name" {  
  type        = string
  description = "The name of the Virtual Network Gateway. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "location of the resources"
}

variable "rgname" {
  type        = string
  description = "resource group for the VPN"
}

variable "vng_type" {
  type        = string
  description = "The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute."
}


variable "vpn_type" {
  type        = string
  description = "The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased"
}

variable "vpn_sku" {
  type        = string
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments. A PolicyBased gateway only supports the Basic SKU. Further, the UltraPerformance SKU is only supported by an ExpressRoute gateway."
}

variable "public_ip_address_id" {
  type        = string
  description = "The ID of the public IP address to associate with the Virtual Network Gateway."  
}

variable "private_ip_address_allocation" {
  type        = string
  description = "Defines how the private IP address of the gateways virtual interface is assigned. Valid options are Static or Dynamic"  
}

variable "subnet_id" {
  type        = string
  description = "The ID of the gateway subnet of a virtual network in which the virtual network gateway will be created. It is mandatory that the associated subnet is named GatewaySubnet. Therefore, each virtual network can contain at most a single Virtual Network Gateway."  
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}