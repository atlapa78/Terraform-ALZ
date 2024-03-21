CustomerName                  = "Amvac Chemical"
CustomerID                    = "amv"
location                      = "westus"
location2                     = "westus3"
environment                   = "alz"
laws_sku                      = "PerGB2018"
retention_days                = 90
keyvault_sku                  = "standard"
soft_delete_retention_days    = 7
account_tier                  = "Standard"
account_replication_type      = "LRS"
createalzkv                   = true
createauditsta                = true
creatediagsta                 = true
createhub1                    = true
createhub2                    = false
create_vms                    = true
create_data_disks             = true
vm_number                     = 1
rsv_sku                       = "Standard"
vault_name                    = "backup"
aut_acc_name                  = "automation"
aut_acc_sku                   = "Basic"
frontend_name                 = "app-LB"
allocation_method             = "Static"
load_balancer_name            = "app_lb"
load_balancer_sku             = "Standard"
private_ip_allocation         = "static"
private_ip                    = "10.46.0.133"
pip_sku                       = "Standard"
vpn_pip_allocation_method     = "Dynamic"
private_ip_address_allocation = "Dynamic"
vng_type                      = "Vpn"
vpn_type                      = "RouteBased"
vpn_sku                       = "VpnGw1"
create_vpn                    = false

audit_rg                      = "audit-logs"
monitoring_rg                 = "monitoring"
action_group                  = "action_group_1"
costmgmt_rg                   = "costmgmt"
keyvault_rg                   = "keys"
hub_network_rg                    = "network"
sharednetwork_rg              = "shared-network"
backup_rg                     = "backup"
aads_rg                       = "app-POWERBI"
app_network_rg                = "app-network"
app_workload_rg               = "app-workload"
recovery_rg                   = "recovery"
shared_sta                    = "Share"
cost_mgmt_sta                 = "costmgmt"
workload_vnetname             = "workload"
hubvnet                       = "hub-network"
pip_vng                       = "vpn_vng"
pip_sku                       = "Standard"
vpn_name                      = "amv-vpn"
platform_keyvault             = "platform-keys"
recovery_sta                  = "recovery"
recovery_aut_acc              = "recovery"
recovery_rsv                  = "asr"

data_disks = {
  disk0 = {
    id        = 0
    disk_size = 8
    disk_type = "Standard_LRS"
  }
  disk1 = {
    id        = 1
    disk_size = 8
    disk_type = "Premium_LRS"
  }
  disk2 = {
    id        = 2
    disk_size = 4
    disk_type = "Premium_LRS"
  }
}

cache_mode        = "None"
number_mngd_disks = 3
#########################################Parameters for virtual machine######################################################
vm_size              = "Standard_B2s"
admin_username       = "eitadm"
vm_publisher         = "MicrosoftWindowsServer"
vm_offer             = "WindowsServer"
vm_sku               = "2016-Datacenter"
vm_version           = "latest"
keyvault_secret_name = "Terraform-vm-password"
#########################################Parameters for virtual machine######################################################



address_space_hub1   = ["10.32.92.0/22"]
address_space_shared = ["10.45.0.0/22"]
address_app_network  = ["10.32.100.0/22"]

subnets_hub1 = {

  subnet0 = {
    index          = 0
    name           = "GatewaySubnet"
    address_prefix = "10.32.95.224/27"
    security_group = "GatewaySubnet-nsg"
    creatensg      = false
    create_rt      = false
  }

  subnet1 = {
    index          = 1
    name           = "AzureFirewallSubnet"
    address_prefix = "10.32.92.0/26"
    security_group = "FirewallSubnet-nsg"
    creatensg      = false
    create_rt      = false
  }

}

subnets_shared = {
  subnet0 = {
    index          = 0
    name           = "sharedServicesSubnet"
    address_prefix = "10.45.0.0/25"
    security_group = "sharedServicesSubnet-nsg"
    creatensg      = true
    create_rt      = true
  }

  #   subnet1 = {
  #     index          = 1
  #     name           = "sharedSubnet"
  #     address_prefix = "10.43.0.0/25"
  #     security_group = "sharedSubnet-nsg"
  #     creatensg      = true
  #   }  
}

app_subnets = {
  subnet0 = {
    index          = 0
    name           = "MgmtSubnet"
    address_prefix = "10.32.100.0/24"
    security_group = "MgmtSubnet-nsg" //added code for seg inside the subnet map if doesnt work remove the code
    creatensg      = true           //added code for seg inside the subnet map if doesnt work remove the code 
    create_rt      = true
  }
  subnet1 = {
    index          = 1
    name           = "VM-Data-Subnet"
    address_prefix = "10.32.103.0/24"
    security_group = "VM-Data-Subnet-nsg"
    creatensg      = true
    create_rt      = true
  }

}


# subnets = {
#   subnet0 = {
#     index          = 0
#     name           = "AVDSubnet"
#     address_prefix = "10.41.0.128/25"
#     security_group = "AVDSubnet-nsg"
#     creatensg      = true
#   }
#   subnet1 = {
#     index          = 1
#     name           = "SharedServicesSubnet"
#     address_prefix = "10.41.0.0/25"
#     security_group = "SharedServicesSubnet-nsg"
#     creatensg      = true
#   }

#   subnet2 = {
#     index          = 2
#     name           = "GatewaySubnet"
#     address_prefix = "10.41.3.224/27"
#     security_group = "GatewaySubnet-nsg"
#     creatensg      = false
#   }
#   subnet3 = {
#     index          = 3
#     name           = "DMZSubnet"
#     address_prefix = "10.41.1.0/26"
#     security_group = "DMZSubnet-nsg"
#     creatensg      = true
#   }
#   subnet4 = {
#     index          = 4
#     name           = "FirewallSubnet"
#     address_prefix = "10.41.3.0/26"
#     security_group = "FirewallSubnet-nsg"
#     creatensg      = false
#   }
#   subnet5 = {
#     index          = 5
#     name           = "TestLinkSubnet"
#     address_prefix = "10.41.3.192/27"
#     security_group = "TestLinkSubnet-nsg"
#     creatensg      = true
#   }
#   subnet6 = {
#     index          = 6
#     name           = "ApplicationGateway"
#     address_prefix = "10.41.3.160/27"
#     security_group = "ApplicationGateway-nsg" //added code for seg inside the subnet map if doesnt work remove the code
#     creatensg      = true                     //added code for seg inside the subnet map if doesnt work remove the code 
#   }

# }
