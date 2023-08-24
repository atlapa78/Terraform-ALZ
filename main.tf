data "azurerm_client_config" "current" {}

locals {
  current_user_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)

  vm_w_mndg_disks = tolist([for vm_name in module.windows_vm[*].vm_name : lower(vm_name)])
  data_disk_type  = tolist([for disk in values(var.data_disks) : lower(tostring(disk.disk_type))])
  data_disk_size  = tolist([for disk in values(var.data_disks) : disk.disk_size])
  data_disk_id    = tolist([for disk in values(var.data_disks) : lower(tostring(disk.id))])
  disks_names_id  = setproduct(local.vm_w_mndg_disks, local.data_disk_id)
  lun_map_names   = [for pair in local.disks_names_id : [
    format("${pair[0]}-data-%02d", pair[1])
    ]
  ]
  lun_map = [for pair in local.disks_names_id : {
    datadisk_name = format("${pair[0]}-data-%02d", pair[1])
    lun           = tonumber(pair[1])
    }
  ]
  luns = { for k in local.lun_map : k.datadisk_name => k.lun }
 // attachment = [for disk in toset(values(module.managed_disks)[*]) : disk.disk_name => disk.disk_id]
}


module "auditlogsrg" {
  source   = "./resourcegroup"
  rgname   = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-rg")
  location = var.location
}

module "keyvaultrg" {
  source   = "./resourcegroup"
  rgname   = lower("${var.CustomerID}-keyvault-alz-${var.regions[var.location]}-rg")
  location = var.location
}

module "networkrg" {
  source   = "./resourcegroup"
  rgname   = lower("${var.CustomerID}-network-alz-${var.regions[var.location]}-rg")
  location = var.location
}

module "operationallogsrg" {
  source   = "./resourcegroup"
  rgname   = lower("${var.CustomerID}-operationallogs-alz-${var.regions[var.location]}-rg")
  location = var.location
}

module "infrastructurerg" {
  source   = "./resourcegroup"
  rgname   = lower("${var.CustomerID}-infrastructure-alz-${var.regions[var.location]}-rg")
  location = var.location
}

module "auditlogsWS" {
  source         = "./loganalyticsWS"
  rgname         = module.auditlogsrg.rg_name
  location       = var.location
  laws_name      = lower("${var.CustomerID}-auditlogs-alz-${var.regions[var.location]}-workspace")
  laws_sku       = var.laws_sku
  retention_days = var.retention_days
  depends_on     = [module.auditlogsrg]
}

module "operationallogsWS" {
  source         = "./loganalyticsWS"
  rgname         = module.operationallogsrg.rg_name
  location       = var.location
  laws_name      = lower("${var.CustomerID}-operationallogs-alz-${var.regions[var.location]}-workspace")
  laws_sku       = var.laws_sku
  retention_days = var.retention_days
  depends_on     = [module.operationallogsrg]
}

module "keyvault" {
  source                     = "./keyvault"
  count                      = var.createalzkv ? 1 : 0
  rgname                     = module.keyvaultrg.rg_name
  location                   = var.location
  vault_name                 = lower("${var.CustomerID}-alz-${var.regions[var.location]}-kv")
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = local.current_user_id
  sku_name                   = var.keyvault_sku
  soft_delete_retention_days = var.soft_delete_retention_days
  #   access_policy {
  #     tenant_id = data.azurerm_client_config.current.tenant_id
  #     object_id = local.current_user_id

  #     key_permissions    = var.key_permissions
  #     secret_permissions = var.secret_permissions
  #   }

  depends_on = [module.keyvaultrg]
}


module "audit_sa" {
  source                   = "./storageaccount"
  count                    = var.createauditsta ? 1 : 0
  storageaccountname       = lower("${var.CustomerID}auditsaalz${var.regions[var.location]}sta")
  rgname                   = module.auditlogsrg.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}


module "operational_sa" {
  source                   = "./storageaccount"
  count                    = var.creatediagsta ? 1 : 0
  storageaccountname       = lower("${var.CustomerID}diagalz${var.regions[var.location]}sta")
  rgname                   = module.operationallogsrg.rg_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

module "vnet_alz" {
  source = "./vnet"
  //count         = var.createalzvnet ? 1 : 0
  vnetname      = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location]}-vnet")
  rgname        = module.networkrg.rg_name
  location      = var.location
  address_space = var.address_space
  subnets       = var.subnets
  environment   = var.environment
}



module "windows_vm" {
  source               = "./vm"
  count                = var.create_vms ? var.vm_number : 0
  location             = var.location
  rgname               = module.infrastructurerg.rg_name
  subnet_id            = module.vnet_alz.subnetiddc
  keyvault_id          = module.keyvault[0].azurerm_key_vault_id
  vm_name              = lower("${var.CustomerID}dc${var.regions[var.location]}p0${count.index}")
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  vm_publisher         = var.vm_publisher
  vm_offer             = var.vm_offer
  vm_sku               = var.vm_sku
  vm_version           = var.vm_version
  keyvault_secret_name = var.keyvault_secret_name

  depends_on = [
    module.vnet_alz,
    module.keyvault
  ]

}

module "managed_disk" {
  source    = "./managed_disk"
  //for_each  = local.luns
  for_each  = var.create_data_disks ? local.luns : { }
  disk_name = each.key  
  location  = var.location
  rgname    = module.infrastructurerg.rg_name
  disk_type = values(var.data_disks)[each.value].disk_type
  disk_size = values(var.data_disks)[each.value].disk_size
  depends_on = [
    module.windows_vm,
    module.infrastructurerg
   ]
}


module "disk_attachment" {
  source               = "./mngd_disk_attachment"
  for_each = length(module.managed_disk) < 1 ? {} : {for disk in values(module.managed_disk)[*] : disk.disk_name => disk.disk_id}
  //for_each             = {for disk in values(module.managed_disk)[*] : disk.disk_name => disk.disk_id}
  disk_id              = each.value
  vm_id                = lookup({for vm in module.windows_vm : vm.vm_name => vm.vm_id}, substr(each.key,0,11))
  lun_id               = tonumber(lookup(local.luns,each.key))
  caching              = var.cache_mode
  depends_on           = [
    module.managed_disk,
    module.windows_vm
  ]
}

output "vm_names" {
  value = local.vm_w_mndg_disks

}

output "data_dsk" {
  value = local.data_disk_id
}

output "disks_names" {

  value = local.disks_names_id
}


output "lun_map" {
  value = local.lun_map
}


output "lun_map_names" {
  value = local.lun_map_names
}

output "luns" {
  value = local.luns
}

output "data_disk_size" {
  value = local.data_disk_size
}

output "data_disk_type" {
  value = local.data_disk_type
}

output "var_disks" {

  value =  values(var.data_disks)[1].disk_type
}


output "windows-vm" {
  value = {for vm in module.windows_vm : vm.vm_name => vm.vm_id}
}

output "disks_ids" {
  value = {for dskid in values(module.managed_disk)[*] : dskid.disk_name => dskid.disk_id}
}


