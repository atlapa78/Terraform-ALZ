CustomerID                 = "sbx"
location                   = "eastus"
environment                = "alz"
laws_sku                   = "PerGB2018"
retention_days             = 90
keyvault_sku               = "standard"
soft_delete_retention_days = 7
account_tier               = "Standard"
account_replication_type   = "LRS"
createalzkv                = true
createauditsta             = true
creatediagsta              = true
createalzvnet              = true
create_vms                 = true
vm_number                  = 2
disk_type                  = "Standard_LRS"
disk_size                  = 4
cache_mode                 = "None"
#########################################Parameters for virtual machine######################################################
vm_size                    = "Standard_B2s"
admin_username             = "eitadm"
vm_publisher               = "MicrosoftWindowsServer"
vm_offer                   = "WindowsServer"
vm_sku                     = "2016-Datacenter"
vm_version                 = "latest"
keyvault_secret_name       = "Terraform-vm-password"
#########################################Parameters for virtual machine######################################################



address_space = ["10.41.0.0/22"]
subnets = {
  subnet0 = {
    index          = 0
    name           = "AVDSubnet"
    address_prefix = "10.41.0.128/25"
    security_group = "AVDSubnet-nsg"
    creatensg      = true
  }
  subnet1 = {
    index          = 1
    name           = "SharedServicesSubnet"
    address_prefix = "10.41.0.0/25"
    security_group = "SharedServicesSubnet-nsg"
    creatensg      = true
  }

  subnet2 = {
    index          = 2
    name           = "GatewaySubnet"
    address_prefix = "10.41.3.224/27"
    security_group = "GatewaySubnet-nsg"
    creatensg      = false
  }
  subnet3 = {
    index          = 3
    name           = "DMZSubnet"
    address_prefix = "10.41.1.0/26"
    security_group = "DMZSubnet-nsg"
    creatensg      = true
  }
  subnet4 = {
    index          = 4
    name           = "FirewallSubnet"
    address_prefix = "10.41.3.0/26"
    security_group = "FirewallSubnet-nsg"
    creatensg      = false
  }
  subnet5 = {
    index          = 5
    name           = "TestLinkSubnet"
    address_prefix = "10.41.3.192/27"
    security_group = "TestLinkSubnet-nsg"
    creatensg      = true
  }
  subnet6 = {
    index          = 6
    name           = "ApplicationGateway"
    address_prefix = "10.41.3.160/27"
    security_group = "ApplicationGateway-nsg" //added code for seg inside the subnet map if doesnt work remove the code
    creatensg      = true                     //added code for seg inside the subnet map if doesnt work remove the code 
  }

}
