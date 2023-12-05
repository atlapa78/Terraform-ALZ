variable "vnetname" {
  description = "name of the Azure vnet"
  type        = string
}



variable "environment" {
  description = "environment where the resources are going to be created"
  type        = string
}

variable "rgname" {
  description = "environment where the resources are going to be created"
  type        = string
}



variable "location" {
  //description = "Location for the resources"
  //type = string

}

variable "address_space" {
  description = "CIDR of the vnet"
  type        = list(any)
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}

# variable "create_nsg" {
#     type = bool
#     default = true
# }

# variable "create_nsg_appgw" {
#     type = bool
#     default = true
# }

variable "subnets" {
  type = map(any)
  # default = {
  #     subnet0 = {
  #         index = 0
  #         name = "AVDSubnet"
  #         address_prefix = "10.41.0.128/25"    
  #         security_group = "AVDSubnet-nsg"
  #         creatensg = true
  #     }
  #     subnet1 = {
  #         index =1
  #         name = "SharedServicesSubnet"
  #         address_prefix = "10.41.0.0/25"
  #         security_group = "SharedServicesSubnet-nsg"
  #         creatensg = true
  #     }

  #     subnet2 =  {
  #         index =2
  #         name = "GatewaySubnet"
  #         address_prefix = "10.41.3.224/27"
  #         security_group = "GatewaySubnet-nsg"
  #         creatensg = false
  #     }
  #     subnet3 = {
  #         index = 3
  #         name = "DMZSubnet"
  #         address_prefix = "10.41.1.0/26"
  #         security_group = "DMZSubnet-nsg"
  #         creatensg = true
  #     }
  #     subnet4 = {
  #         index = 4
  #         name = "FirewallSubnet"
  #         address_prefix = "10.41.3.0/26"
  #         security_group = "FirewallSubnet-nsg"
  #         creatensg = false
  #     }
  #    subnet5 = {
  #         index = 5
  #         name = "PrivateLinkSubnet"
  #         address_prefix = "10.41.3.192/27"
  #         security_group = "PrivateLinkSubnet-nsg"
  #         creatensg = true
  #     }
  #     subnet6 = {
  #         index = 6
  #         name = "ApplicationGateway"
  #         address_prefix = "10.41.3.160/27"
  #         security_group = "ApplicationGateway-nsg"  //added code for seg inside the subnet map if doesnt work remove the code
  #         creatensg = true                            //added code for seg inside the subnet map if doesnt work remove the code 
  #     }

  # }

}

# variable "regions" {
#   description = "Map of Azure regions to id regions p/e es1"
#   type        = map(any)
#   default = {
#     eastasia           = "ea"
#     southeastasia      = "sea"
#     australiacentral   = "auc"
#     australiacentral2  = "auc2"
#     australiaeast      = "aue"
#     australiasoutheast = "ause"
#     chinaeast          = "che"
#     chinaeast2         = "che2"
#     chinanorth         = "chn"
#     chinanorth2        = "chn2"
#     centralindia       = "inc"
#     southindia         = "ins"
#     westindia          = "inw"
#     japaneast          = "jae"
#     japanwest          = "jaw"
#     koreacentral       = "koc"
#     koreasouth         = "kos"
#     southafricanorth   = "san"
#     southafricawest    = "saw"
#     uaecentral         = "uac"
#     uaenorth           = "uan"
#     qatarcentral       = "qac"
#     francecentral      = "fc"
#     francesouth        = "frs"
#     germanynorth       = "grn"
#     germanywestcentral = "gwc"
#     norwayeast         = "noe"
#     norwaywest         = "now"
#     switzerlandnorth   = "swn"
#     switzerlandwest    = "sww"
#     uksouth            = "uks"
#     ukwest             = "ukw"
#     northeurope        = "ne"
#     westeurope         = "we"
#     brazilsouth        = "brs"
#     canadacentral      = "cac"
#     canadaeast         = "cae"
#     centralus          = "cu"
#     eastus             = "es1"
#     eastus2            = "es2"
#     northcentralus     = "ncu"
#     southcentralus     = "scu"
#     westcentralus      = "wcu"
#     westus             = "wu"
#     westus2            = "wu2"
#   }
# }


