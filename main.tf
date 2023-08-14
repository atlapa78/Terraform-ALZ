data "azurerm_client_config" "current" {}

locals {
  current_user_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
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
  source = "./keyvault"
  //count                      = var.createalzkv ? 1 : 0
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
  location             = var.location
  rgname               = module.infrastructurerg.rg_name
  subnet_id            = module.vnet_alz.subnetiddc
  keyvault_id          = module.keyvault.azurerm_key_vault_id
  vm_name              = lower("${var.CustomerID}dc${var.regions[var.location]}p0")
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  vm_publisher         = var.vm_publisher
  vm_offer             = var.vm_offer
  vm_sku               = var.vm_sku
  vm_version           = var.vm_version
  keyvault_secret_name = var.keyvault_secret_name
  depends_on           = [module.vnet_alz]
}

module "managed_disk" {
  source               = "./managed_disk"
  disk_name            = lower("${module.windows_vm.vm_name}-data-01")
  location             = var.location
  rgname               = module.infrastructurerg.rg_name
  disk_type            = var.disk_type
  disk_size            = var.disk_size
}

module "disk_attachment" {
  source               = "./mngd_disk_attachment"
  disk_id              = module.managed_disk.disk_id
  vm_id                = module.windows_vm.vm_id
  lun_id               = 1
  caching              = var.cache_mode
  depends_on           = [
    module.managed_disk,
    module.windows_vm
  ]
}
