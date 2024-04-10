terraform { 
  //required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }



  }
}

provider "azurerm" {
  features {}
}

# # provider "azurerm" {
# #   //alias           = "platform"

# #   subscription_id = "76eaa65e-b2f7-4eb4-b96c-f91db52fbe8a"
# #   tenant_id       = "6b0ee7fd-8166-47a9-bc89-31a540f0ddff"
# #   client_id       = "1a0463b5-b07b-41ef-be76-446bf018420f"
# #   client_secret   = "Def8Q~.-oDxpvoXd-Oy~18hzW5d8YLGKpYuaudt4"
  

# #   features {}
# # }

# # provider "azurerm" {
# #   //alias           = "workload"

# #   subscription_id = "90c683e6-c3fa-4edf-ac00-224e0cb7a33c"
# #   tenant_id       = "f2c37eb9-9dcb-4bf0-a7de-087cc7d414af"
# #   client_id       = "7e419d06-e03a-4b7b-8662-1676f116fb04"
# #   client_secret   = "9k38Q~weE-IYRDtm_pE_fbtzR77KBaHXRxEH7bnU"

   
# #   features {}  
# # }

# #######uncomment when run in Azure Devops and rename backend.tf and providers.tf


data "azurerm_client_config" "current" {}

locals {
  current_user_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
  ntwk_rules_data = csvdecode(file("fw_net_rules.csv"))
  network_rules = {
    for ntwk_rule_iteration in local.ntwk_rules_data :
    "${ntwk_rule_iteration.name}.${ntwk_rule_iteration.source_addresses}.${ntwk_rule_iteration.destination_addresses}.${ntwk_rule_iteration.protocols}.${ntwk_rule_iteration.destination_ports}" => {
      rule_name        = ntwk_rule_iteration.name
      rule_protocols   = ntwk_rule_iteration.protocols
      rule_src_address = ntwk_rule_iteration.source_addresses
      rule_dst_address = ntwk_rule_iteration.destination_addresses
      rule_dst_ports   = formatlist("%s",split(",",ntwk_rule_iteration.destination_ports))
      //rule_priority    = ntwk_rule_iteration.priority
    }
  }


  

#   # vm_w_mndg_disks = tolist([for vm_name in module.windows_vm[*].vm_name : lower(vm_name)])
#   # data_disk_type  = tolist([for disk in values(var.data_disks) : lower(tostring(disk.disk_type))])
#   # data_disk_size  = tolist([for disk in values(var.data_disks) : disk.disk_size])
#   # data_disk_id    = tolist([for disk in values(var.data_disks) : lower(tostring(disk.id))])
#   # disks_names_id  = setproduct(local.vm_w_mndg_disks, local.data_disk_id)
#   # lun_map_names = [for pair in local.disks_names_id : [
#   #   format("${pair[0]}-data-%02d", pair[1])
#   #   ]
#   # ]
#   # lun_map = [for pair in local.disks_names_id : {
#   #   datadisk_name = format("${pair[0]}-data-%02d", pair[1])
#   #   lun           = tonumber(pair[1])
#   #   }
#   # ]
#   # luns = { for k in local.lun_map : k.datadisk_name => k.lun }

# #######################################################Local variables for App Vnet####################################################################
#   app_subnet_ids          = tolist([for sub in module.workload_vnet.subnets : sub.id ])
#   app_rt_ids              = tolist([for rt in module.workload_vnet_rt.route_tables : rt.id])   ##### cambiar por modulo de route tables para obtner los IDs
#   app_subnet_names        = tolist([for i in values(var.app_subnets) : i.name if i.create_rt])
#   app_rt_associations     = tomap({
#     subnet_id = flatten([for subname in local.app_subnet_names : [ for subid in local.app_subnet_ids : subid if strcontains(subid,subname)]])
#     rt_id     = flatten([for subname in local.app_subnet_names : [ for rtid in local.app_rt_ids : rtid if strcontains(rtid,subname)]])
#   })
#   app_rt_sub_associations = zipmap(values(local.app_rt_associations)[1], values(local.app_rt_associations)[0])

# #######################################################Local variables for App Vnet####################################################################


# #######################################################Local variables for hub1 Vnet####################################################################
#   # hub1_subnet_ids          = tolist([for sub in module.hub_vnet_rgn1.subnets : sub.id ])
#   # hub1_rt_ids              = tolist([for rt in module.hub_vnet_rgn1_rt.route_tables  : rt.id])
#   # hub1_subnet_names        = tolist([for i in values(var.subnets_hub1) : i.name if i.create_rt])
#   # hub1_rt_associations     = tomap({
#   #   subnet_id = flatten([for subname in local.hub1_subnet_names : [ for subid in local.hub1_subnet_ids : subid if strcontains(subid,subname)]])
#   #   rt_id     = flatten([for subname in local.hub1_subnet_names : [ for rtid in local.hub1_rt_ids : rtid if strcontains(rtid,subname)]])
#   # })
#   # hub1_rt_sub_associations = zipmap(values(local.hub1_rt_associations)[1], values(local.hub1_rt_associations)[0])

# #######################################################Local variables for hub1 Vnet####################################################################



# # #######################################################Local variables for shared Vnet####################################################################
#   shared_subnet_ids          = module.shared_subnets.subnets
#   shared_rt_ids              = tolist([for rt in module.shared_subnets_rt.route_tables : rt.id])
#   shared_subnet_names        = tolist([for i in values(var.subnets_shared) : i.name if i.create_rt])
#   shared_rt_associations     = tomap({
#   subnet_id = flatten([for subname in local.shared_subnet_names : [ for subid in local.shared_subnet_ids : subid if strcontains(subid,subname)]])
#   rt_id     = flatten([for subname in local.shared_subnet_names : [ for rtid in local.shared_rt_ids : rtid if strcontains(rtid,subname)]])
#   })
#   shared_rt_sub_associations = zipmap(values(local.shared_rt_associations)[1], values(local.shared_rt_associations)[0])

# # #######################################################Local variables for shared Vnet####################################################################

}


# # module "parent_mgmt" {
# #   source          = "./az_mgmt_group"
# #   mgmt_display    = "${var.CustomerName}100"
# # }

# # module "mgmt_mgmt" {
# #   source          = "./az_mgmt_group"
# #   mgmt_display    = "Management"
# #   parent_mgmt_group_id = module.parent_mgmt.mgmt_id
# #   depends_on = [ 
# #     module.parent_mgmt
# #   ]
# # }

# # module "audit_mgmt" {
# #   source          = "./az_mgmt_group"
# #   mgmt_display    = "Audit"
# #   parent_mgmt_group_id = module.parent_mgmt.mgmt_id  
# #   depends_on = [ 
# #     module.parent_mgmt
# #   ]  
# # }

# # module "infra_mgmt" {
# #   source          = "./az_mgmt_group"
# #   mgmt_display    = "Infrastructure"
# #   parent_mgmt_group_id = module.parent_mgmt.mgmt_id
# #   depends_on = [ 
# #     module.parent_mgmt
# #   ]
# # }

# # module "work_mgmt" {
# #   source          = "./az_mgmt_group"
# #   mgmt_display    = "Workloads01"
# #   # parent_mgmt_group_id = module.parent_mgmt.mgmt_id  
# #   # depends_on = [ 
# #   #   module.parent_mgmt
# #   # ]
# # }

# # resource "azurerm_management_group_subscription_association" "infra_association" {
# #   management_group_id = module.infra_mgmt.mgmt_id
# #   subscription_id     = data.azurerm_client_config.current.subscription_id
# # }


   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   ######  #          #    ####### ####### ####### ######  #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #     # #         # #      #    #       #     # #     # ##   ##   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #     # #        #   #     #    #       #     # #     # # # # # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   ######  #       #     #    #    #####   #     # ######  #  #  #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #       #       #######    #    #       #     # #   #   #     # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #       #       #     #    #    #       #     # #    #  #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #       ####### #     #    #    #       ####### #     # #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
                                                                                                                                                                                                                                 
                                                                 
module "auditlogs_rg" {
  source = "./az_resource_group"
  # providers = {
  #   azurerm = azurerm.platform
  # }
  rgname   = lower("${var.audit_rg}-glb-rg")
  location = var.location
  tags_rg = {
  }
}

module "costmgmt_rg" {
  source = "./az_resource_group"
  # providers = {
  #   azurerm = azurerm.platform
  # }
  //rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
  rgname   = lower("${var.costmgmt_rg}-glb-rg")
  location = var.location
  tags_rg = null
}

module "cost_mgmt_sta" {
  source                   = "./az_storage_account"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count                    = var.createcoststa ? 1 : 0
  //storageaccountname       = lower("${var.CustomerID}diagalz${var.regions[var.location]}sta")
  storageaccountname       = lower("${var.cost_mgmt_sta}${var.regions[var.location]}sta")
  rgname                   = module.costmgmt_rg.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags_rsrc = {
    # Environment             = "Management"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on               = [
                               module.costmgmt_rg
                             ]
}

module "auditlogs_log" {
  source         = "./az_log_analitycs"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  rgname         = module.auditlogs_rg.rg_name
  location       = var.location
  //laws_name      = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-workspace")
  laws_name      = lower("${var.audit_laws_name}-${var.regions[var.location]}-workspace")
  laws_sku       = var.laws_sku
  retention_days = var.retention_days
  tags_rsrc = null
  depends_on = [module.auditlogs_rg]
}

module "audit_sta" {
  source                   = "./az_storage_account"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count                    = var.createauditsta ? 1 : 0
  //storageaccountname       = lower("${var.CustomerID}auditsaalz${var.regions[var.location]}sta")
  storageaccountname       = lower("${var.audit_sta_name}${var.regions[var.location]}sta")
  rgname                   = module.auditlogs_rg.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags_rsrc = {
    # Environment             = "Audit"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on               = [
                               module.auditlogs_rg
                             ]
}

module "monitoring_rg" {
  source = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  //rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
  rgname   = lower("${var.monitoring_rg}-glb-rg")
  location = var.location
  tags_rg = {
    # Environment = "Management"
    # Location    = var.location
  }
}

# # # module "action_group_test" {
# # #   source      = "./az_monitor_action_group"
# # #    providers = {
# # #     azurerm = azurerm.platform
# # #   }
# # #   action_name = var.action_group
# # #   rgname      = module.monitoring_RG.rg_name
# # # }


module "monitoring_log" {
  source = "./az_log_analitycs"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  //rgname         = module.operationallogsrg.rg_name
  rgname         = module.monitoring_rg.rg_name
  location       = var.location
  //laws_name      = lower("${var.CustomerID}-operationallogs-alz-${var.regions[var.location]}-workspace")
  laws_name      = lower("${var.monitoring_log_name}-${var.regions[var.location]}-workspace")
  laws_sku       = var.laws_sku
  retention_days = var.retention_days
  tags_rsrc = {
    # Environment             = "Management"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on = [module.monitoring_rg]
}


module "keyvault_rg" {
  source            = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count             = var.createalzkv ? 1 : 0
  //rgname   = lower("${var.CustomerID}-keyvault-alz-${var.regions[var.location]}-rg")
  rgname            = lower("${var.keyvault_rg}-glb-rg")
  location          = var.location
  tags_rg           = {
    # Environment = "Management"
    # Location    = var.location
  }
}



module "keyvault" {
  source = "./az_keyvault"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count                      = var.createalzkv ? 1 : 0
  //rgname                     = module.keyvaultrg.rg_name
  rgname                     = module.keyvault_rg[0].rg_name
  location                   = var.location
  key_vault_name             = lower("${var.platform_keyvault}-${var.regions[var.location]}-kv")
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = local.current_user_id
  sku_name                   = var.keyvault_sku
  soft_delete_retention_days = var.soft_delete_retention_days
  tags_rsrc = {
    # Environment             = "Management"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on = [module.keyvault_rg]
}

# # # module "secret_key" {
# # #   source               = "./az_secret_key"
# # #    providers = {
# # #     azurerm = azurerm.platform
# # #   }
# # #   keyvault_secret_name = var.keyvault_secret_name
# # #   key_vault_id         = module.keyvault[0].azurerm_key_vault_id
# # #   tags_rsrc = {
# # #     # Environment             = "Audit"
# # #     # Location                = var.location
# # #     # "Bussiness Criticality" = "High"
# # #     # "Data Classification"   = "General"
# # #     # "Business unit"         = "N/A"
# # #     # "Operations team"       = "Cloud Operations"
# # #     # "Cost center"           = "Exactlyit"
# # #   }
# # #   depends_on = [module.keyvault]
# # # }


module "backup_rg" {
  source = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  //rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  rgname   = lower("${var.backup_rg}-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    # Environment = "Shared"
    # Location    = var.location
  }
}

module "backup_recovery_service_vault" {
  source     = "./az_recovery_service_vault"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  vault_name = lower("${var.vault_name}-${var.regions[var.location]}-rsv")
  rgname     = module.backup_rg.rg_name
  location   = var.location
  tags_rsrc = {
    # Environment             = "Shared"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on = [module.backup_rg]
}


module "hub_network_rg" {
  source = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  //rgname   = lower("${var.CustomerID}-network-alz-${var.regions[var.location]}-rg")
  rgname   = lower("${var.hub_network_rg}-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    # Environment = "Connectivity"
    # Location    = var.location
  }
}

module "hub_vnet" {
  source            =  "./az_virtual_network_v2"
  vnetname          = lower("${var.hubvnet}-${var.regions[var.location]}-vnet")
  rgname            = module.hub_network_rg.rg_name
  location          = var.location
  address_space     = var.address_space_hub1
  tags_rsrc         = null
  depends_on        = [ 
                        module.hub_network_rg  
                      ]
}

module "hub_gw_subnet" {
  source            = "./az_subnet_v2"
  subnet_name       = element(values(var.subnets_hub1),0).name
  rgname            = module.hub_network_rg.rg_name  
  vnet              = module.hub_vnet.vnet_name
  address_space     = [element(values(var.subnets_hub1),0).address_prefix]
  tags_rsrc         = null
  depends_on        = [ 
                        module.hub_network_rg,
                        module.hub_vnet
                     ]
}


module "hub_fw_subnet" {
  source            = "./az_subnet_v2"
  subnet_name       = element(values(var.subnets_hub1),1).name
  rgname            = module.hub_network_rg.rg_name  
  vnet              = module.hub_vnet.vnet_name
  address_space     = [element(values(var.subnets_hub1),1).address_prefix]
  tags_rsrc         = null
  depends_on        = [ 
                        module.hub_network_rg,
                        module.hub_vnet
                     ]
}

module "mgmt_fw_subnet" {
  source            = "./az_subnet_v2"
  subnet_name       = element(values(var.subnets_hub1),2).name
  rgname            = module.hub_network_rg.rg_name  
  vnet              = module.hub_vnet.vnet_name
  address_space     = [element(values(var.subnets_hub1),2).address_prefix]
  tags_rsrc         = null
  depends_on        = [ 
                        module.hub_network_rg,
                        module.hub_vnet
                     ]
}

module "sharednetwork_rg" {
  source = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  rgname   = lower("${var.sharednetwork_rg}-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    # Environment = "Shared"
    # Location    = var.location
  }
}


module "shared_vnet" {
  source            =  "./az_virtual_network_v2"
  vnetname          = lower("${var.sharedvnet}-${var.regions[var.location]}-vnet")
  rgname            = module.sharednetwork_rg.rg_name
  location          = var.location
  address_space     = var.address_space_shared
  tags_rsrc         = null
  depends_on        = [ 
                        module.sharednetwork_rg 
                      ]
}


module "identity_subnet" {
  source            = "./az_subnet_v2"
  subnet_name       = element(values(var.subnets_shared),0).name
  rgname            = module.sharednetwork_rg.rg_name  
  vnet              = module.shared_vnet.vnet_name
  address_space     = [element(values(var.subnets_shared),0).address_prefix]
  tags_rsrc         = null
  depends_on        = [
                        module.sharednetwork_rg,
                        module.shared_vnet            
                      ]
}

module "identity_subnet-nsg" {
  source            = "./az_nsg"
  nsg_name          = "${element(values(var.subnets_shared),0).name}-nsg"
  rgname            = module.sharednetwork_rg.rg_name
  location          = var.location
  depends_on        = [
                        module.sharednetwork_rg,
                        module.shared_vnet,
                        module.identity_subnet          
                      ]
}


module "sub_identity_nsg_association" {
  source            = "./az_network_security_group_association"
  subnet_id         = module.identity_subnet.subnet_id
  nsg_id            = module.identity_subnet-nsg.nsg_id
  depends_on        = [
                       module.sharednetwork_rg,
                       module.shared_vnet,
                       module.identity_subnet,
                       module.identity_subnet-nsg 
                      ]
}


module "identity_subnet-rt" {
  source            = "./az_route_table_v2"
  rgname            = module.sharednetwork_rg.rg_name
  rt_name           = "${element(values(var.subnets_shared),0).name}-rt"
  location          = var.location
  subnets           = var.subnets_shared
  address_space     = element(values(var.subnets_shared),0).address_prefix
  depends_on        = [
                        module.sharednetwork_rg,
                        module.shared_vnet,
                        module.identity_subnet, 
                      ]
}

module "sub_identity_rt_association" {
  source            = "./az_route_association"
  subnet_id         = module.identity_subnet.subnet_id
  rt_id             = module.identity_subnet-rt.id
  depends_on        = [
                        module.sharednetwork_rg,
                        module.shared_vnet,
                        module.identity_subnet,
                        module.identity_subnet-rt 
                      ]
}


module "vpn_pip" {
  source            = "./az_public_IP"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  location          = var.location
  pip_name          = lower("${var.pip_vng}-${var.regions[var.location]}-pip")
  rgname            = module.hub_network_rg.rg_name
  allocation_method = var.vpn_pip_allocation_method
  pip_sku           = var.pip_sku
  tags_rsrc = {
    # Environment             = "PRD"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on        = [ 
                        module.hub_network_rg
                      ]
}

module "fw_pip" {
  source            = "./az_public_IP"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  location          = var.location
  pip_name          = lower("${var.pip_fw}-${var.regions[var.location]}-pip")
  rgname            = module.hub_network_rg.rg_name
  allocation_method = var.allocation_method
  pip_sku           = var.pip_sku
  tags_rsrc         = {
    # Environment             = "PRD"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on        = [ 
                        module.hub_network_rg
                      ]
}

module "mgmt_fw_pip" {
  source            = "./az_public_IP"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  location          = var.location
  pip_name          = lower("${var.mgmt_pip_fw}-${var.regions[var.location]}-pip")
  rgname            = module.hub_network_rg.rg_name
  allocation_method = var.allocation_method
  pip_sku           = var.pip_sku
  tags_rsrc = {
    # Environment             = "PRD"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on        = [ 
                        module.hub_network_rg
                      ]
}


module "pip_nat_gw" {
  source            = "./az_public_IP"
  count             = var.create_pip_nat_gw ? 1 : 0
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  location          = var.location
  pip_name          = lower("${var.pip_nat_gw}-${var.regions[var.location]}-pip")
  rgname            = module.hub_network_rg.rg_name
  allocation_method = var.vpn_pip_allocation_method
  pip_sku           = var.pip_sku
  tags_rsrc = {
    # Environment             = "PRD"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on = [module.hub_network_rg]
}

module "baseline_fw_policy" {
  source            = "./az_firewall_policy"
  fw_policy_name    = var.fw_policy_name
  fw_policy_rg      = module.hub_network_rg.rg_name
  location          = var.location
}

module "fw_net_rules" {
  source                       = "./az_firewall_net_policy_rule"
  az_fw_policy_rule_name       = var.az_fw_policy_group_rule_name//"network-rule-collection-group-01"
  az_fw_policy_net_rule_name   = var.az_fw_policy_net_rule_name
  fw_policy_id                 = module.baseline_fw_policy.az_fw_policy
  //location                     = var.location
  ntwk_rules_data              = local.network_rules
  priority_group_rule          = var.priority_group_rule
  priority_net_rule            = var.priority_net_rule
  az_fw_policy_net_rule_action = var.az_fw_policy_net_rule_action

}

module "az_hub_firewall" {
  source            = "./az_firewall"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count             = var.createfirewall ? 1 : 0
  fw_name           = lower("${var.fw_name}-${var.regions[var.location]}-01")
  location          = var.location
  rgname            = module.hub_network_rg.rg_name
  fw_sku_name       = var.fw_sku_name
  fw_sku_tier       = var.fw_sku_tier
  #fw_subnet_id      = element(module.hub_vnet_rgn1.fwsubnetid,0)
  fw_subnet_id      = module.hub_fw_subnet.subnet_id
  fw_pip_id         = module.fw_pip.pip_id
  mgmt_fw_subnet_id = module.mgmt_fw_subnet.subnet_id
  mgmt_fw_pip_id    = module.mgmt_fw_pip.pip_id
  depends_on        = [ 
                        module.hub_network_rg,
                        module.hub_vnet,
                        module.hub_fw_subnet,
                        module.mgmt_fw_subnet,
                        module.fw_pip,
                        module.mgmt_fw_pip
                      ]  
}



module "vpn_s2s" {
  source                        = "./az_vpn"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count                         = var.create_vpn ? 1 : 0
  //vpn_name                      = lower("${var.CustomerID}-${var.regions[var.location]}-vpn-vng")
  vpn_name                      = lower("${var.vpn_name}-${var.regions[var.location]}-vng")
  location                      = var.location
  rgname                        = module.hub_network_rg.rg_name
  vng_type                      = var.vng_type
  vpn_type                      = var.vpn_type
  vpn_sku                       = var.vpn_sku
  public_ip_address_id          = module.vpn_pip.pip_id
  private_ip_address_allocation = var.private_ip_address_allocation
  //subnet_id                     = element(module.hub_vnet_rgn1.gatewayid, 0)
  subnet_id                     = module.hub_gw_subnet.subnet_id
  tags_rsrc = {
    # Environment             = "PRD"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on                    = [
                                    module.vpn_pip,
                                    module.hub_vnet,
                                    module.hub_network_rg
                                  ]
}


module "recovery_rg" {
  source = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  rgname   = lower("${var.recovery_rg}-${var.regions[var.location2]}-rg")
  location = var.location2
  tags_rg = {
    # Environment = "DR"
    # Location    = var.location
  }
}


module "recovery_sta" {
  source                   = "./az_storage_account"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count                    = var.createauditsta ? 1 : 0
  storageaccountname       = lower("${var.recovery_sta}${var.regions[var.location2]}sta")
  rgname                   = module.recovery_rg.rg_name
  location                 = var.location2
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags_rsrc = {
    # Environment             = "DR"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on = [module.recovery_rg]
}


module "dr_aut_acc" {
  source      = "./az_automation_acc"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  count       = var.deploy_dr_aut_acc ? 1 :0
  auto_name   = "${var.recovery_aut_acc}-${var.regions[var.location2]}-autacc"
  location    = var.location
  rgname      = module.recovery_rg.rg_name
  aut_acc_sku = var.aut_acc_sku
  tags_rsrc = {
    # Environment             = "DR"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on = [module.recovery_rg]
}


module "dr_rsv" {
  source     = "./az_recovery_service_vault"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  vault_name = lower("${var.recovery_rsv}-${var.regions[var.location2]}-rsv")
  rgname     = module.recovery_rg.rg_name
  location   = var.location2
  tags_rsrc = {
    # Environment             = "DR"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "General"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
  }
  depends_on = [module.recovery_rg]
}


module "aads_rg" {
  source = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.platform
  # }
  rgname   = lower("${var.aads_rg}-${var.regions[var.location]}-rg")
  location = var.location
  tags_rg = {
    # Environment = "Shared"
    # Location    = var.location
  }
}

module "windows_vm" {
  source         = "./az_windows_vm"
  count          = var.create_vms ? var.vm_number : 0
  location       = var.location
  rgname         = module.aads_rg.rg_name
  subnet_id      = module.identity_subnet.subnet_id  
  vm_name        = "DC-AVD01"//lower("DC$(upper${var.regions[var.location]}")
  vm_size        = var.vm_size
  admin_username = var.admin_username
  vm_publisher   = var.vm_publisher
  vm_offer       = var.vm_offer
  vm_sku         = var.vm_sku
  vm_version     = var.vm_version
  vm_password    = var.vm_password
  keyvault_id    = null
  tags_rsrc = {
    # Environment             = "Domain Controller"
    # Location                = var.location
    # "Bussiness Criticality" = "High"
    # "Data Classification"   = "Confidential"
    # "Business unit"         = "N/A"
    # "Operations team"       = "Cloud Operations"
    # "Cost center"           = "Exactlyit"
    # "Disaster Recovery"     = "DR required"
    # "Patching"              = "Win-3-Sat-CST-Reboot"
    # "Backup"                = "Commvault"
  }
  depends_on = [
    module.aads_rg,
    module.shared_vnet
  ]

}

# # module "app_RG" {
# #   source = "./az_resource_group"
# #   #  providers = {
# #   #   azurerm = azurerm.platform
# #   # }
# #   rgname   = lower("${var.app_rg}-${var.regions[var.location]}-rg")
# #   location = var.location
# #   tags_rg = {
# #     # Environment = "Shared"
# #     # Location    = var.location
# #   }
# # }
# # module "shared_vnet" {
# #   source = "./az_virtual_network"
# #   #  providers = {
# #   #   azurerm = azurerm.platform
# #   # }
# #   //count         = var.createhub1 ? 1 : 0
# #   //vnetname      = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location]}-vnet")
# #   vnetname      = lower("${var.sharedvnet}-${var.regions[var.location]}-vnet")
# #   rgname        = module.sharednetwork_RG.rg_name
# #   location      = var.location
# #   address_space = var.address_space_shared
# #   subnets       = var.subnets_shared
# #   environment   = var.environment
# #   tags_rsrc = {
# #     # Environment             = "Shared"
# #     # Location                = var.location
# #     # "Bussiness Criticality" = "High"
# #     # "Data Classification"   = "General"
# #     # "Business unit"         = "N/A"
# #     # "Operations team"       = "Cloud Operations"
# #     # "Cost center"           = "Exactlyit"
# #   }
# #   depends_on = [module.sharednetwork_RG]
# # }

# # module "shared_vnet_rt" {
# #   source        = "./az_route_table"
# #   #  providers = {
# #   #   azurerm = azurerm.platform
# #   # }
# #   subnets       =  var.subnets_shared
# #   rgname        = module.sharednetwork_RG.rg_name
# #   location      = var.location
# #   address_space = var.address_space_shared
# #   depends_on    = [module.shared_vnet]
# # }



   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   ######  #          #    ####### ####### ####### ######  #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #     # #         # #      #    #       #     # #     # ##   ##   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #     # #        #   #     #    #       #     # #     # # # # # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   ######  #       #     #    #    #####   #     # ######  #  #  #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #       #       #######    #    #       #     # #   #   #     # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #       #       #     #    #    #       #     # #    #  #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #       ####### #     #    #    #       ####### #     # #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
                                                                                                                                                                                                                                 


   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #     # ####### ######  #    # #       #######    #    ######    # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #  #  # #     # #     # #   #  #       #     #   # #   #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #  #  # #     # #     # #  #   #       #     #  #   #  #     # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #  #  # #     # ######  ###    #       #     # #     # #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #  #  # #     # #   #   #  #   #       #     # ####### #     # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #  #  # #     # #    #  #   #  #       #     # #     # #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #    ## ##  ####### #     # #    # ####### ####### #     # ######    # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
                                                                                                                                                                                                                                

module "app_network_rg" {
  source = "./az_resource_group"
  rgname   = "${var.app_network_rg}-${var.regions[var.location]}-rg"
  location = var.location
  tags_rg = {
    # Environment = "PRD"
    # Location    = var.location
  }
}

module "workload_vnet" {
  source            =  "./az_virtual_network_v2"
  vnetname          = lower("${var.workload_vnetname}-${var.regions[var.location]}-vnet")
  rgname            = module.app_network_rg.rg_name
  location          = var.location
  address_space     = var.address_app_network
  tags_rsrc         = null
}

module "management_subnet" {
  source            = "./az_subnet_v2"
  subnet_name       = element(values(var.app_subnets),0).name
  rgname            = module.app_network_rg.rg_name  
  vnet              = module.workload_vnet.vnet_name
  address_space     = [element(values(var.app_subnets),0).address_prefix]
  tags_rsrc         = null
}

module "vm_data_subnet" {
  source            = "./az_subnet_v2"
  subnet_name       = element(values(var.app_subnets),1).name
  rgname            = module.app_network_rg.rg_name  
  vnet              = module.workload_vnet.vnet_name
  address_space     = [element(values(var.app_subnets),1).address_prefix]
  tags_rsrc         = null
}

module "management_subnet-rt" {
  source            = "./az_route_table_v2"
  rgname            = module.app_network_rg.rg_name
  rt_name           = "${element(values(var.app_subnets),0).name}-rt"
  location          = var.location
  subnets           = var.subnets_shared
  address_space     = element(values(var.app_subnets),0).address_prefix
}

module "vm_data_subnet-rt" {
  source            = "./az_route_table_v2"
  rgname            = module.app_network_rg.rg_name
  rt_name           = "${element(values(var.app_subnets),1).name}-rt"
  location          = var.location
  subnets           = var.subnets_shared
  address_space     = element(values(var.app_subnets),1).address_prefix
}


module "sub_mgmt_rt_association" {
  source            = "./az_route_association"
  subnet_id         = module.management_subnet.subnet_id
  rt_id             = module.management_subnet-rt.id
  depends_on        = [module.app_network_rg,
                       module.workload_vnet,
                       module.management_subnet,                       
                       module.management_subnet ]
}

module "sub_vm_data_rt_association" {
  source            = "./az_route_association"
  subnet_id         = module.vm_data_subnet.subnet_id
  rt_id             = module.vm_data_subnet-rt.id
  depends_on        = [module.app_network_rg,
                       module.workload_vnet,                      
                       module.vm_data_subnet,                       
                       module.vm_data_subnet-rt ]
}

module "management_subnet-nsg" {
  source            = "./az_nsg"
  nsg_name          = "${element(values(var.app_subnets),0).name}-nsg"
  rgname            = module.app_network_rg.rg_name
  location          = var.location
}


module "management_subnet_nsg_association" {
  source            = "./az_network_security_group_association"
  subnet_id         = module.management_subnet.subnet_id
  nsg_id            = module.management_subnet-nsg.nsg_id
  depends_on        = [module.app_network_rg,
                       module.workload_vnet,
                       module.management_subnet,
                       module.management_subnet-nsg ]
}

module "vm_data_subnet-nsg" {
  source            = "./az_nsg"
  nsg_name          = "${element(values(var.app_subnets),1).name}-nsg"
  rgname            = module.app_network_rg.rg_name
  location          = var.location
}


module "vm_data_subnet_nsg_association" {
  source            = "./az_network_security_group_association"
  subnet_id         = module.vm_data_subnet.subnet_id
  nsg_id            = module.vm_data_subnet-nsg.nsg_id
  depends_on        = [module.app_network_rg,
                       module.workload_vnet,                      
                       module.vm_data_subnet,                       
                       module.vm_data_subnet-nsg ]
}

module "app_rg" {
  source = "./az_resource_group"
  #  providers = {
  #   azurerm = azurerm.workload
  # }
  rgname   = "${var.app_rg}-${var.regions[var.location]}-rg"
  location = var.location
  tags_rg = {
    # Environment = "Shared"
    # Location    = var.location
  }
}

# module "workload_vnet" {
#   source = "./az_virtual_network"
#   #  providers = {
#   #   azurerm = azurerm.workload
#   # }
#   //count         = var.createhub1 ? 1 : 0
#   //vnetname      = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location]}-vnet")
#   vnetname      = "${var.workload_vnetname}-${var.regions[var.location]}-vnet"
#   rgname        = module.app_network_rg.rg_name
#   location      = var.location
#   address_space = var.address_app_network
#   subnets       = var.app_subnets
#   environment   = var.environment
#   tags_rsrc = {
#     # Environment             = "PRD"
#     # Location                = var.location
#     # "Bussiness Criticality" = "High"
#     # "Data Classification"   = "General"
#     # "Business unit"         = "N/A"
#     # "Operations team"       = "Cloud Operations"
#     # "Cost center"           = "Exactlyit"
#   }
#   depends_on = [module.app_network_rg]
# }

# module "workload_vnet_rt" {
#   source        = "./az_route_table"
#   #  providers = {
#   #   azurerm = azurerm.workload
#   # }
#   subnets       =  var.app_subnets
#   rgname        = module.app_network_rg.rg_name
#   location      = var.location
#   address_space = var.address_app_network
#   depends_on    = [module.workload_vnet]
# }



   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #     # ####### ######  #    # #       #######    #    ######    # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #  #  # #     # #     # #   #  #       #     #   # #   #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #  #  # #     # #     # #  #   #       #     #  #   #  #     # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #  #  # #     # ######  ###    #       #     # #     # #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
 ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### #  #  # #     # #   #   #  #   #       #     # ####### #     # ####### ####### ####### ####### ####### ####### ####### ####### ####### ####### 
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   #  #  # #     # #    #  #   #  #       #     # #     # #     #   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
   # #     # #     # #     # #     # #     # #     # #     # #     # #     # #    ## ##  ####### #     # #    # ####### ####### #     # ######    # #     # #     # #     # #     # #     # #     # #     # #     # #     # #   
                                                                                                                                                                                                                                



output "hub_subnets" {
  value = module.hub_gw_subnet
}


output "fw_net_rules" {
  value = local.ntwk_rules_data
}

output "network_rules" {
  value = local.network_rules
}


output "fw_policy_id" {
  value = module.baseline_fw_policy.az_fw_policy
}

# output "shared_subnets" {
#   value = module.shared_subnets.subnets
# }

# output "workload_subnets" {
#   value = module.workload_subnets.subnets
# }

# output "shared_rt_sub_associations" {
#   value  = local.shared_rt_sub_associations
# }
