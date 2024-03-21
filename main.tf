# terraform {
#   required_version = ">= 1.0"
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">=2.54.0"
#     }

#     random = {
#       source  = "hashicorp/random"
#       version = "3.1.0"
#     }

#   }
  
#   backend "azurerm" {

#     resource_group_name  = "Terraform-lab-rg"
#     storage_account_name = "alcavdes1tsa1"
#     container_name       = "terraform"
#     key                  = "terraform.tfstate"
#   }
# }

# provider "azurerm" {
#    features {}
# }


#######uncomment when run in Azure Devops and rename backend.tf and providers.tf


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

#######################################################Local variables for App Vnet####################################################################
  app_subnet_ids          = tolist([for sub in module.app_vnet.subnets : sub.id ])
  app_rt_ids              = tolist([for rt in module.app_vnet_rt.route_tables : rt.id])   ##### cambiar por modulo de route tables para obtner los IDs
  app_subnet_names        = tolist([for i in values(var.app_subnets) : i.name if i.create_rt])
  app_rt_associations     = tomap({
    subnet_id = flatten([for subname in local.app_subnet_names : [ for subid in local.app_subnet_ids : subid if strcontains(subid,subname)]])
    rt_id     = flatten([for subname in local.app_subnet_names : [ for rtid in local.app_rt_ids : rtid if strcontains(rtid,subname)]])
  })
  app_rt_sub_associations = zipmap(values(local.app_rt_associations)[1], values(local.app_rt_associations)[0])

#######################################################Local variables for App Vnet####################################################################


#######################################################Local variables for hub1 Vnet####################################################################
  hub1_subnet_ids          = tolist([for sub in module.hub_vnet_rgn1.subnets : sub.id ])
  hub1_rt_ids              = tolist([for rt in module.hub_vnet_rgn1_rt.route_tables  : rt.id])
  hub1_subnet_names        = tolist([for i in values(var.subnets_hub1) : i.name if i.create_rt])
  hub1_rt_associations     = tomap({
    subnet_id = flatten([for subname in local.hub1_subnet_names : [ for subid in local.hub1_subnet_ids : subid if strcontains(subid,subname)]])
    rt_id     = flatten([for subname in local.hub1_subnet_names : [ for rtid in local.hub1_rt_ids : rtid if strcontains(rtid,subname)]])
  })
  hub1_rt_sub_associations = zipmap(values(local.app_rt_associations)[1], values(local.app_rt_associations)[0])

#######################################################Local variables for hub1 Vnet####################################################################

#######################################################Local variables for hub2 Vnet####################################################################
  hub2_subnet_ids          = tolist([for sub in module.hub_vnet_rgn2.subnets : sub.id ])
  hub2_rt_ids              = tolist([for rt in module.hub_vnet_rgn2_rt.route_tables : rt.id])
  hub2_subnet_names        = tolist([for i in values(var.subnets_hub2) : i.name if i.create_rt])
  hub2_rt_associations     = tomap({
    subnet_id = flatten([for subname in local.hub2_subnet_names : [ for subid in local.hub2_subnet_ids : subid if strcontains(subid,subname)]])
    rt_id     = flatten([for subname in local.hub2_subnet_names : [ for rtid in local.hub2_rt_ids : rtid if strcontains(rtid,subname)]])
  })
  hub2_rt_sub_associations = zipmap(values(local.hub2_rt_associations)[1], values(local.hub2_rt_associations)[0])

#######################################################Local variables for hub2 Vnet####################################################################

#######################################################Local variables for shared Vnet####################################################################
  shared_subnet_ids          = tolist([for sub in module.shared_vnet.subnets : sub.id ])
  shared_rt_ids              = tolist([for rt in module.shared_vnet_rt.route_tables : rt.id])
  shared_subnet_names        = tolist([for i in values(var.subnets_shared) : i.name if i.create_rt])
  shared_rt_associations     = tomap({
    subnet_id = flatten([for subname in local.shared_subnet_names : [ for subid in local.shared_subnet_ids : subid if strcontains(subid,subname)]])
    rt_id     = flatten([for subname in local.shared_subnet_names : [ for rtid in local.shared_rt_ids : rtid if strcontains(rtid,subname)]])
  })
  shared_rt_sub_associations = zipmap(values(local.shared_rt_associations)[1], values(local.shared_rt_associations)[0])

#######################################################Local variables for shared Vnet####################################################################

}


module "parent_mgmt" {
  source          = "./az_mgmt_group"
  mgmt_display    = "${var.CustomerName}100"
}

module "mgmt_mgmt" {
  source          = "./az_mgmt_group"
  mgmt_display    = "Management"
  parent_mgmt_group_id = module.parent_mgmt.mgmt_id
  depends_on = [ 
    module.parent_mgmt
  ]
}

module "audit_mgmt" {
  source          = "./az_mgmt_group"
  mgmt_display    = "Audit"
  parent_mgmt_group_id = module.parent_mgmt.mgmt_id  
  depends_on = [ 
    module.parent_mgmt
  ]  
}

module "infra_mgmt" {
  source          = "./az_mgmt_group"
  mgmt_display    = "Infrastructure"
  parent_mgmt_group_id = module.parent_mgmt.mgmt_id
  depends_on = [ 
    module.parent_mgmt
  ]
}

module "work_mgmt" {
  source          = "./az_mgmt_group"
  mgmt_display    = "Workloads01"
  # parent_mgmt_group_id = module.parent_mgmt.mgmt_id  
  # depends_on = [ 
  #   module.parent_mgmt
  # ]
}

# resource "azurerm_management_group_subscription_association" "infra_association" {
#   management_group_id = module.infra_mgmt.mgmt_id
#   subscription_id     = data.azurerm_client_config.current.subscription_id
# }

####################################################################################################################################################
####################################################################################################################################################
####################################################################################################################################################
############################################AUDIT SUBSCRIPTION######################################################################################
module "auditlogs_RG" {
  source = "./az_resource_group"
  rgname   = lower("${var.audit_rg}-glb-rg")
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
  rgname   = lower("${var.monitoring_rg}-glb-rg")
  location = var.location
  tags_rg = {
    Environment = "Management"
    Location    = var.location
  }
}

module "action_group_test" {
  source      = "./az_monitor_action_group"
  action_name = "test_action_group"
  rgname      = module.monitoring_RG.rg_name
}

module "costmgmt_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
  rgname   = lower("${var.costmgmt_rg}-glb-rg")
  location = var.location
  tags_rg = {
    Environment = "Management"
    Location    = var.location
  }
}

module "keyvault_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-keyvault-alz-${var.regions[var.location]}-rg")
  rgname   = lower("${var.keyvault_rg}-glb-rg")
  location = var.location
  tags_rg = {
    Environment = "Management"
    Location    = var.location
  }
}


module "operationallogs_WS" {
  source = "./az_log_analitycs"
  //rgname         = module.operationallogsrg.rg_name
  rgname         = module.monitoring_RG.rg_name
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
  depends_on = [module.monitoring_RG]
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
  depends_on = [module.monitoring_RG]
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
  rgname   = lower("${var.network_rg}-${var.regions[var.location]}-rg")
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
  vnetname      = lower("hubvnet-${var.regions[var.location]}-1")
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

module "hub_vnet_rgn1_rt" {
  source        = "./az_route_table"
  subnets       =  var.subnets_hub1
  rgname        = module.network_RG.rg_name
  location      = var.location
  address_space = var.address_space_hub1
  depends_on    = [module.hub_vnet_rgn1]
}

module "hub_vnet_rgn1_rt_association" {
  source          = "./az_route_association"
  rt_associations = local.hub1_rt_sub_associations
  depends_on = [ module.hub_vnet_rgn1,
                 module.hub_vnet_rgn1_rt ]
}

module "hub_vnet_rgn2" {
  source = "./az_virtual_network"
  //count  = var.createhub2 ? 1 : 0
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

module "hub_vnet_rgn2_rt" {
  source        = "./az_route_table"
  subnets       = var.subnets_hub2
  rgname        = module.network_RG.rg_name
  location      = var.location2
  address_space = var.address_space_hub2
  depends_on    = [module.hub_vnet_rgn2]
}


module "vpn_pip" {
  source            = "./az_public_IP"
  location          = var.location
  pip_name          = lower("${var.CustomerID}-${var.regions[var.location]}-vpn-pip")
  rgname            = module.network_RG.rg_name
  allocation_method = var.vpn_pip_allocation_method
  pip_sku           = "Basic"
  tags_rsrc = {
    Environment             = "PRD"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [module.network_RG]
}


module "vpn_s2s" {
  source                        = "./az_vpn"
  count                         = var.create_vpn ? 1 : 0
  vpn_name                      = lower("${var.CustomerID}-${var.regions[var.location]}-vpn-vng")
  location                      = var.location
  rgname                        = module.network_RG.rg_name
  vng_type                      = var.vng_type
  vpn_type                      = var.vpn_type
  vpn_sku                       = var.vpn_sku
  public_ip_address_id          = module.vpn_pip.pip_id
  private_ip_address_allocation = var.private_ip_address_allocation
  subnet_id                     = element(module.hub_vnet_rgn1.gatewayid, 0)
  tags_rsrc = {
    Environment             = "PRD"
    Location                = var.location
    "Bussiness Criticality" = "High"
    "Data Classification"   = "General"
    "Business unit"         = "N/A"
    "Operations team"       = "Cloud Operations"
    "Cost center"           = "Exactlyit"
  }
  depends_on = [ module.vpn_pip, module.app_network_rg, module.network_RG]
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
  rgname   = lower("${var.sharednetwork_rg}-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "Shared"
    Location    = var.location
  }
}

module "backup_RG" {
  source = "./az_resource_group"
  //rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  rgname   = lower("${var.backup_rg}-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "Shared"
    Location    = var.location
  }
}

module "aads_RG" {
  source = "./az_resource_group"
  rgname   = lower("${var.aads_rg}-${var.regions[var.location]}-rg")
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
  depends_on = [module.sharednetwork_RG]
}

module "shared_vnet_rt" {
  source        = "./az_route_table"
  subnets       =  var.subnets_shared
  rgname        = module.sharednetwork_RG.rg_name
  location      = var.location
  address_space = var.address_space_shared
  depends_on    = [module.shared_vnet]
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
  vm_id   = lookup({ for vm in module.windows_vm : vm.vm_name => vm.vm_id }, substr(each.key, 0, 11))  //replace lenght vm.vm_name with eleven
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
  storageaccountname       = lower("${var.shared_sta}${var.regions[var.location]}sta")
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
  rgname   = lower("${var.app_network_rg}-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    Environment = "PRD"
    Location    = var.location
  }
}

module "app_workload_rg" {
  source = "./az_resource_group"
  rgname   = lower("${var.app_workload_rg}-${var.regions[var.location]}-rg")
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
  depends_on = [module.app_network_rg]
}

module "app_vnet_rt" {
  source        = "./az_route_table"
  subnets       =  var.app_subnets
  rgname        = module.app_network_rg.rg_name
  location      = var.location
  address_space = var.address_space_shared
  depends_on    = [module.shared_vnet]
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
  depends_on = [module.app_network_rg]
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
  rgname   = lower("${var.recovery_rg}-${var.regions[var.location2]}-rg")
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

# output "subnetlbid1" {
#   value = element(module.app_vnet.subnetlbid, 0)
# }

# output "subnetnamesfor" {
#   value = module.app_vnet.subnetnames
# }

# output "hub_vnet_rgn1" {
#   value = module.hub_vnet_rgn1.subnetnames
# }


# output "rtapp_vnet" {
#   value = module.app_vnet.rtnames
# }

# output "rthub_vnet_rgn1" {
#   value = module.hub_vnet_rgn1.rtnames
# }

# output "hub_vnet_rgn1_assoc" {
#   value = module.hub_vnet_rgn1.rtassociations
# }

# output "app_vnet_assoc" {
#   //value = zipmap(module.app_vnet.rtassociations[0],module.app_vnet.rtassociations[1])
#   value = module.app_vnet.rtassociations
# }
