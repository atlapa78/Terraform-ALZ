######################General purpose variables##########################
variable "regions" {
  description = "Map of Azure regions to id regions p/e es1"
  type        = map(any)
  default = {
    eastasia           = "ea"
    southeastasia      = "sea"
    australiacentral   = "auc"
    australiacentral2  = "auc2"
    australiaeast      = "aue"
    australiasoutheast = "ause"
    chinaeast          = "che"
    chinaeast2         = "che2"
    chinanorth         = "chn"
    chinanorth2        = "chn2"
    centralindia       = "inc"
    southindia         = "ins"
    westindia          = "inw"
    japaneast          = "jae"
    japanwest          = "jaw"
    koreacentral       = "koc"
    koreasouth         = "kos"
    southafricanorth   = "san"
    southafricawest    = "saw"
    uaecentral         = "uac"
    uaenorth           = "uan"
    qatarcentral       = "qac"
    francecentral      = "fc"
    francesouth        = "frs"
    germanynorth       = "grn"
    germanywestcentral = "gwc"
    norwayeast         = "noe"
    norwaywest         = "now"
    switzerlandnorth   = "swn"
    switzerlandwest    = "sww"
    uksouth            = "uks"
    ukwest             = "ukw"
    northeurope        = "ne"
    westeurope         = "we"
    brazilsouth        = "brs"
    canadacentral      = "cac"
    canadaeast         = "cae"
    centralus          = "cu"
    eastus             = "es1"
    eastus2            = "es2"
    northcentralus     = "ncu"
    southcentralus     = "scu"
    westcentralus      = "wcu"
    westus             = "wu"
    westus2            = "wu2"
  }
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"  
}

variable "CustomerID" {
  description = "ID for the new customer"
  type        = string
}


variable "location" {
  type        = string
  description = "location of the resources"
}

variable "location2" {
  type        = string
  description = "Paired region of location"
}
######################General purpose variables##########################

######################Log Analitycs Workspace variables##########################
variable "laws_sku" {
  type        = string
  description = "SKU for the log analytics workspace"
  validation {
    condition     = contains(["Free", "Standard", "CapacityReservation", "PerGB2018"], var.laws_sku)
    error_message = "Valid values for the log analytics work space variable are Free, Standard, CapacityReservation"
  }
  default = "PerGB2018"
}

variable "retention_days" {
  type        = number
  description = "retention in days for log analytics work space"
  default     = 30
}
######################Log Analitycs Workspace variables##########################

######################Keyvault variables##########################
variable "createalzkv" {
  type        = bool
  description = "used for audit keyvault creation"
  default     = true
}

variable "keyvault_sku" {
  type        = string
  description = "SKU for the keyvault"
  default     = "standard"
}

variable "key_permissions" {
  type        = list(string)
  description = "List of key permissions."
  default     = ["List", "Create", "Delete", "Get", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy"]
}

variable "secret_permissions" {
  type        = list(string)
  description = "List of secret permissions."
  default     = ["Set"]
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. If this value isn't null (the default), 'data.azurerm_client_config.current.object_id' will be set to this value."
  default     = null
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of day for the retention for the keyvault"
}
######################Keyvault variables##########################

######################Storage Account variables##########################

variable "createauditsta" {
  type        = bool
  description = "used for audit keyvault creation"
  default     = true
}

variable "creatediagsta" {
  type        = bool
  description = "used for audit keyvault creation"
  default     = true
}

variable "account_tier" {
  type        = string
  description = "Tier for storage account, valid values: Standard, Premium"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Replication to use for storage account, valid values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS"
  default     = "LRS"
}

######################Storage Account variables##########################


######################Azure Vnet variables##########################
variable "createhub1" {
  type        = bool
  description = "used for vnet hub1 creation"
  default     = true
}

variable "createhub2" {
  type        = bool
  description = "used for vnet hub2 creation"
  default     = true
}

variable "environment" {
  description = "environment where the resources are going to be created"
  type        = string
}

variable "address_space_hub1" {
  description = "CIDR of the vnet for hub1"
  type        = list(any)
}

variable "address_space_hub2" {
  description = "CIDR of the vnet for hub2"
  type        = list(any)
}


variable "address_space_shared" {
  description = "CIDR of the vnet for shared"
  type        = list(any)
}

variable "address_app_network" {
  description = "CIDR of the vnet for app workload"
  type        = list(any)
}

variable "subnets_hub1" {
  type = map(any)
}

variable "subnets_hub2" {
  type = map(any)
}


variable "subnets_shared" {
  type = map(any)
}

variable "app_subnets" {
  type = map(any)
}

variable "frontend_name" {
  type        = string
  description = "Name of the public IP for frontend LB"

}

variable "allocation_method" {
  type        = string
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  default     = "Dynamic"

}

######################Azure Vnet variables##########################


################################################Azure virtual machines variables################################################

variable "vm_purpose" {
  description = "Map of the purpose for virtual machines"
  type        = map(any)
  default = {
    domaincontroller = "dc"
    webserver        = "web"
    appserver        = "app"
    databaseserver   = "db"
    fileserver       = "fs"
    sapserver        = "sap"
    proxyserver      = "pxs"
  }
}

variable "create_vms" {
  type        = bool
  description = "value used for the vm creation"

}

variable "vm_number" {
  type        = number
  description = "number of domain controllers to be created"
}

variable "vm_size" {
  type        = string
  description = "virtual machine size"
}

variable "admin_username" {
  type        = string
  description = "username"
  default     = "azureuser"
}

variable "vm_publisher" {
  type        = string
  description = "Virtual machine publisher"
}

variable "vm_offer" {
  type        = string
  description = "Virtual machine offer"
}

variable "vm_sku" {
  type        = string
  description = "Virtual machine sku"
}

variable "vm_version" {
  type        = string
  description = "Virtual machine os version"
  default     = "latest"
}


variable "keyvault_secret_name" {
  type        = string
  description = "virtual machine secret name"
  default     = "vmpassword"
}


################################################Azure virtual machines variables################################################


################################################Managed Disks variables################################################

variable "number_mngd_disks" {
  type        = number
  description = "Number of managed data disks for the vms"
}

variable "create_data_disks" {
  type        = bool
  description = "Variable to create or not managed disks"
}

variable "data_disks" {
  description = "Size and tye of the data disks"
  type        = map(any)
  default = {
    disk_type = "Standard_LRS"
    disk_size = 4
  }
}




################################################Managed Disks variables################################################

################################################Managed Disks Attachemnt variables################################################
variable "cache_mode" {
  type        = string
  description = "Caching mode for the managed disk. Possible values include None, ReadOnly and ReadWrite"
}
################################################Managed Disks Attachemnt variables################################################

################################################Recovery Service Vault variables################################################
variable "vault_name" {
  type        = string
  description = "Name used for the recovery services vault"

}

variable "rsv_sku" {
  type        = string
  description = "(Required) Sets the vault's SKU. Possible values include: Standard, RS0."
  default     = "Standard"
}

################################################Recovery Service Vault variables################################################

##################################################Automation Account variables##################################################
variable "aut_acc_name" {
  type        = string
  description = "Name of the automation account"

}

variable "aut_acc_sku" {
  type        = string
  description = " (Required) The SKU of the account. Possible values are Basic and Free"
  default     = "free"
}
##################################################Automation Account variables##################################################

#####################################################Load Balancer variables####################################################
variable "load_balancer_name" {
  type        = string
  description = "Name of the Load Balancer"
}

variable "load_balancer_sku" {
  type        = string
  description = "SKU of the Load Balancer, allowed values are Standard and Gateway"
}

variable "private_ip_allocation" {
  type        = string
  description = "Allocation type for the private IP address"
}

variable "private_ip" {
  description = "The private IP for the load balancer"
}

variable "pip_sku" {
  type        = string
  description = "The SKU of the Public IP. Accepted values are Basic and Standard,  Changing this forces a new resource to be created."
}

#####################################################Load Balancer variables####################################################