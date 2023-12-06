terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.54.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

  }
  
  backend "azurerm" {

    resource_group_name  = "Terraform-lab-rg"
    storage_account_name = "alcavdes1tsa1"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
   features {}
}

data "azurerm_client_config" "current" {}

locals {
  current_user_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)

  vm_w_mndg_disks = tolist([for vm_name in module.windows_vm[*].vm_name : lower(vm_name)])
  data_disk_type  = tolist([for disk in values(var.data_disks) : lower(tostring(disk.disk_type))])
  data_disk_size  = tolist([for disk in values(var.data_disks) : disk.disk_size])
  data_disk_id    = tolist([for disk in values(var.data_disks) : lower(tostring(disk.id))])
  disks_names_id  = setproduct(local.vm_w_mndg_disks, local.data_disk_id)
  lun_map_names = [for pair in local.disks_names_id : [
    format("${pair[0]}-data-%02d", pair[1])
    ]
  ]
  lun_map = [for pair in local.disks_names_id : {
    datadisk_name = format("${pair[0]}-data-%02d", pair[1])
    lun           = tonumber(pair[1])
    }
  ]
  luns = { for k in local.lun_map : k.datadisk_name => k.lun }

}

####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################
############################################AUDIT SUBSCRIPTION######################################################################################
module "auditlogs_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
  rgname   = "auditlogs-glb-rg"
  location = var.location
  tags_rg = {
    Environment = "Audit"
    Location    = var.location
  }
}

module "auditlogs_WS" {
  source         = "./az_log_analitycs"
  rgname         = module.auditlogs_RG.rg_name
  location       = var.location
  laws_name      = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-workspace")
  laws_sku       = var.laws_sku
  retention_days = var.retention_days
  tags_rsrc = {
    Environment             = "Audit"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.auditlogs_RG]
}

module "audit_SA" {
  source                   = "./az_storage_account"
  count                    = var.createauditsta ? 1 : 0
  storageaccountname       = lower("${var.CustomerID}auditsaalz${var.regions[var.location]}sta")
  rgname                   = module.auditlogs_RG.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags_rsrc = {
    Environment             = "Audit"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.auditlogs_RG]
}

############################################AUDIT SUBSCRIPTION######################################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################


############################################MANAGEMENT SUBSCRIPTION#################################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################

# module "monitoring_mgmt_RG" {
#   source   = "./az_resource_group"
#   //rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
#   rgname = "monitoring-glb-rg"
#   location = var.location
# }

module "monitoring_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
  rgname   = "monitoring-glb-rg"
  location = var.location
  tags_rg = {
    Environment = "Management"
    Location    = var.location
  }
}

module "costmgmt_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
  rgname   = "costmgmt-glb-rg"
  location = var.location
  tags_rg = {
    Environment = "Management"
    Location    = var.location
  }
}

module "keyvault_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-keyvault-alz-${var.regions[var.location]}-rg")
  rgname   = "keys-glb-rg"
  location = var.location
  tags_rg = {
    Environment = "Management"
    Location    = var.location
  }
}


module "operationallogs_WS" {
  source = "./az_log_analitycs"
  //rgname         = module.operationallogsrg.rg_name
  rgname         = module.keyvault_RG.rg_name
  location       = var.location
  laws_name      = lower("${var.CustomerID}-operationallogs-alz-${var.regions[var.location]}-workspace")
  laws_sku       = var.laws_sku
  retention_days = var.retention_days
  tags_rsrc = {
    Environment             = "Management"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.keyvault_RG]
}

module "keyvault" {
  source = "./az_keyvault"
  count  = var.createalzkv ? 1 : null
  //rgname                     = module.keyvaultrg.rg_name
  rgname                     = module.keyvault_RG.rg_name
  location                   = var.location
  key_vault_name             = lower("${var.CustomerID}-alz-${var.regions[var.location]}-kv")
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = local.current_user_id
  sku_name                   = var.keyvault_sku
  soft_delete_retention_days = var.soft_delete_retention_days
  tags_rsrc = {
    Environment             = "Management"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.keyvault_RG]
}

module "secret_key" {
  source               = "./az_secret_key"
  keyvault_secret_name = var.keyvault_secret_name
  key_vault_id         = module.keyvault[0].azurerm_key_vault_id
  tags_rsrc = {
    Environment             = "Audit"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.keyvault]
}

module "management_SA" {
  source                   = "./az_storage_account"
  count                    = var.creatediagsta ? 1 : 0
  storageaccountname       = lower("${var.CustomerID}diagalz${var.regions[var.location]}sta")
  rgname                   = module.costmgmt_RG.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags_rsrc = {
    Environment             = "Management"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.costmgmt_RG]
}

module "mgmt_aut_acc" {
  source      = "./az_automation_acc"
  auto_name   = "${var.aut_acc_name}-${var.regions[var.location2]}-autacc"
  location    = var.location2
  rgname      = module.costmgmt_RG.rg_name
  aut_acc_sku = var.aut_acc_sku
  tags_rsrc = {
    Environment             = "Management"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.costmgmt_RG]
}

############################################MANAGEMENT SUBSCRIPTION#################################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################


############################################CONNECTIVITY SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################

module "network_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-network-alz-${var.regions[var.location]}-rg")
  rgname   = lower("network-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "Connectivity"
    Location    = var.location
  }
}

module "hub_vnet_rgn1" {
  source = "./az_virtual_network"
  //count         = var.createhub1 ? 1 : 0
  //vnetname      = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location]}-vnet")
  vnetname      = lower("hubvnet-${var.regions[var.location]}1")
  rgname        = module.network_RG.rg_name
  location      = var.location
  address_space = var.address_space_hub1
  subnets       = var.subnets_hub1
  environment   = var.environment
  tags_rsrc = {
    Environment             = "Connectivity"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.network_RG]

}

module "hub_vnet_rgn2" {
  source = "./az_virtual_network"
  count  = var.createhub2 ? 1 : 0
  //vnetname      = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location2]}-vnet")
  vnetname      = lower("hubvnet-${var.regions[var.location2]}2")
  rgname        = module.network_RG.rg_name
  location      = var.location2
  address_space = var.address_space_hub2
  subnets       = var.subnets_hub2
  tags_rsrc = {
    Environment             = "Connectivity"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.network_RG]
  environment = var.environment
}

############################################CONNECTIVITY SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################


##################################################SHARED SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################


module "sharednetwork_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-operationallogs-alz-${var.regions[var.location]}-rg")
  rgname   = lower("shared-network-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "Shared"
    Location    = var.location
  }
}

module "backup_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  rgname   = lower("backup-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "Shared"
    Location    = var.location
  }
}

module "aads_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  rgname   = lower("aads-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "Shared"
    Location    = var.location
  }
}

module "az_recovery_service_vault" {
  source     = "./az_recovery_service_vault"
  vault_name = lower("${var.vault_name}-${var.regions[var.location]}-rsv")
  rgname     = module.backup_RG.rg_name
  location   = var.location
  tags_rsrc = {
    Environment             = "Shared"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.backup_RG]
}

module "shared_vnet" {
  source = "./az_virtual_network"
  //count         = var.createhub1 ? 1 : 0
  //vnetname      = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location]}-vnet")
  vnetname      = lower("sharedvnet-${var.regions[var.location]}")
  rgname        = module.sharednetwork_RG.rg_name
  location      = var.location
  address_space = var.address_space_shared
  subnets       = var.subnets_shared
  environment   = var.environment
  tags_rsrc = {
    Environment             = "Shared"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on[module.sharednetwork_RG]
}

module "windows_vm" {
  source         = "./az_windows_vm"
  count          = var.create_vms ? var.vm_number : 0
  location       = var.location
  rgname         = module.aads_RG.rg_name
  subnet_id      = module.shared_vnet.subnetiddc
  keyvault_id    = module.keyvault[0].azurerm_key_vault_id
  vm_name        = lower("${var.CustomerID}dc${var.regions[var.location]}p0${count.index}")
  vm_size        = var.vm_size
  admin_username = var.admin_username
  vm_publisher   = var.vm_publisher
  vm_offer       = var.vm_offer
  vm_sku         = var.vm_sku
  vm_version     = var.vm_version
  vm_password    = module.secret_key.key_vault_secret
  tags_rsrc = {
    Environment             = "Domain Controller"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "Confidential"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
    "Disaster Recovery"     = "DR required"
    "Patching"              = "Win-3-Sat-CST-Reboot"
    "Backup"                = "Commvault"
  }
  depends_on = [
    module.aads_RG,
    module.keyvault,
    module.shared_vnet
  ]

}

module "managed_disk" {
  source = "./az_managed_disk"
  //for_each  = local.luns
  for_each  = var.create_data_disks ? local.luns : {}
  disk_name = each.key
  location  = var.location
  rgname    = module.aads_RG.rg_name
  disk_type = values(var.data_disks)[each.value].disk_type
  disk_size = values(var.data_disks)[each.value].disk_size
  tags_rsrc = {
    Environment             = "Shared"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [
    module.windows_vm,
    module.aads_RG
  ]
}


module "disk_attachment" {
  source   = "./az_mngd_disk_attachment"
  for_each = length(module.managed_disk) < 1 ? {} : { for disk in values(module.managed_disk)[*] : disk.disk_name => disk.disk_id }
  //for_each             = {for disk in values(module.managed_disk)[*] : disk.disk_name => disk.disk_id}
  disk_id = each.value
  vm_id   = lookup({ for vm in module.windows_vm : vm.vm_name => vm.vm_id }, substr(each.key, 0, 11))
  lun_id  = tonumber(lookup(local.luns, each.key))
  caching = var.cache_mode
  depends_on = [
    module.aads_RG,
    module.managed_disk,
    module.windows_vm
  ]
}

module "shared_SA" {
  source                   = "./az_storage_account"
  count                    = var.creatediagsta ? 1 : 0
  storageaccountname       = lower("shared${var.regions[var.location]}sta")
  rgname                   = module.aads_RG.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags_rsrc = {
    Environment             = "Shared"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.aads_RG]
}

##################################################SHARED SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################



#####################################################PRD SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################
module "app_network_rg" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  rgname   = lower("app-network${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "PRD"
    Location    = var.location
  }
}

module "app_workload_rg" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  rgname   = lower("app-workload${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "PRD"
    Location    = var.location
  }
}

module "app_vnet" {
  source = "./az_virtual_network"
  //count         = var.createhub1 ? 1 : 0
  //vnetname      = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location]}-vnet")
  vnetname      = lower("app-${var.regions[var.location]}-vnet")
  rgname        = module.app_network_rg.rg_name
  location      = var.location
  address_space = var.address_app_network
  subnets       = var.app_subnets
  environment   = var.environment
  tags_rsrc = {
    Environment             = "PRD"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on[module.app_network_rg]
}

module "lb_frontend" {
  source            = "./az_public_IP"
  location          = var.location
  pip_name          = var.frontend_name
  rgname            = module.app_network_rg.rg_name
  allocation_method = var.allocation_method
  pip_sku           = var.pip_sku
  tags_rsrc = {
    Environment             = "PRD"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on[module.app_network_rg]
}

module "load_balancer" {
  source                = "./az_load_balancer"
  az_lb_name            = var.load_balancer_name
  location              = var.location
  rgname                = module.app_network_rg.rg_name
  lb_sku                = var.load_balancer_sku
  subnet_lb_id          = element(module.app_vnet.subnetlbid, 0)
  frontend_name         = module.lb_frontend.pip_name
  private_ip_allocation = var.private_ip_allocation
  private_ip            = var.private_ip
  //public_ip_address_id = module.lb_frontend.pip_id
  tags_rsrc = {
    Environment             = "PRD"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.app_network_rg]
}

#####################################################PRD SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################



######################################################DR SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################
module "recovery_rg" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  rgname   = lower("recovery${var.regions[var.location2]}-rg")
  location = var.location2
  tags_rg = {
    Environment = "DR"
    Location    = var.location
  }
}


module "recovery_SA" {
  source                   = "./az_storage_account"
  count                    = var.createauditsta ? 1 : 0
  storageaccountname       = lower("${var.CustomerID}recovery${var.regions[var.location2]}sta")
  rgname                   = module.recovery_rg.rg_name
  location                 = var.location2
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags_rsrc = {
    Environment             = "DR"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.recovery_rg]
}


module "dr_aut_acc" {
  source      = "./az_automation_acc"
  auto_name   = "recovery-${var.regions[var.location2]}-autacc"
  location    = var.location2
  rgname      = module.recovery_rg.rg_name
  aut_acc_sku = var.aut_acc_sku
  tags_rsrc = {
    Environment             = "DR"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.recovery_rg]
}


module "dr_rsv" {
  source     = "./az_recovery_service_vault"
  vault_name = lower("dr-${var.regions[var.location2]}-rsv")
  rgname     = module.recovery_rg.rg_name
  location   = var.location2
  tags_rsrc = {
    Environment             = "DR"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.recovery_rg]
}

######################################################DR SUBSCRIPTION###############################################################################
####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################





# output "vm_names" {
#   value = local.vm_w_mndg_disks

# }

# output "data_dsk" {
#   value = local.data_disk_id
# }

# output "disks_names" {

#   value = local.disks_names_id
# }


# output "lun_map" {
#   value = local.lun_map
# }


# output "lun_map_names" {
#   value = local.lun_map_names
# }

# output "luns" {
#   value = local.luns
# }

# output "data_disk_size" {
#   value = local.data_disk_size
# }

# output "data_disk_type" {
#   value = local.data_disk_type
# }

# output "var_disks" {

#   value =  values(var.data_disks)[1].disk_type
# }


# output "windows-vm" {
#   value = {for vm in module.windows_vm : vm.vm_name => vm.vm_id}
# }

# output "disks_ids" {
#   value = {for dskid in values(module.az_managed_disk)[*] : dskid.disk_name => dskid.disk_id}
# }

# output "keyvault"{
#   value = module.az_key_vault
# }

output "subnetlbid1" {
  value = element(module.app_vnet.subnetlbid, 0)
}

